Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2GMS0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:26:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57310 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828Ab2GMS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:26:13 -0400
Message-ID: <1342203970.3039.35.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Runtime updates to EFI secure variables
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 19:26:10 +0100
In-Reply-To: <20120713180231.GA19355@srcf.ucam.org>
References: <1342199546.3039.30.camel@dabdike.int.hansenpartnership.com>
	 <20120713180231.GA19355@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 19:02 +0100, Matthew Garrett wrote:
> On Fri, Jul 13, 2012 at 06:12:26PM +0100, James Bottomley wrote:
> 
> > This means (provided we have access to the relevant keys) we can move
> > the platform into and out of Setup Mode as well as add signing and other
> > keys.
> 
> I'm pretty sure that the expected behaviour is to use 
> EFI_VARIABLE_APPEND_WRITE for these updates, which means you don't need 
> to worry about the timestamp.

Actually, as long as the timestamp is current (as in > previous
timstamp) it updates the private timestamp stored with the variable.
It's minor, and you're right, the timestamp could be zero, but it's best
practice.

As far as moving the platform into setup mode, that can only be done by
clearing PK, which has to be a non append write, so I need to worry
about both modes.  It's useful to make sure this works, just in case we
run into some OEM accidentally forgetting to allow a user present reset
to setup mode, because it allows us to create an EFI program for them
that will have the same effect.

James


