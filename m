Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1LLP3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:29:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1LLP3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:29:44 -0500
Message-ID: <1323703737.21400.3.camel@twins>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 Dec 2011 16:28:57 +0100
In-Reply-To: <20111212150255.GA7506@kroah.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	 <20111212150255.GA7506@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 07:02 -0800, Greg KH wrote:
> On Mon, Dec 12, 2011 at 02:44:52PM +0200, Daniel Baluta wrote:
> > We can easily get kref refcount value by accesing
> > kref->refcount but it is better to have a function
> > for this.
> 
> No, you should NEVER need the value of the kref, if you do, you are
> doing something wrong.
> 
> What code needs this patch?

I very much agree with Greg, those sites that know wth they're doing are
way better off open-coding it like they do now. (I only looked at the
neihgbour.c one, which is creative but not evidently wrong).

Providing a kref_read() function however, suggests its actually a sane
thing to do, its not.
