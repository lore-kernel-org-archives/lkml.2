Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2FLQVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:21:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58445 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720Ab2FLQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:21:14 -0400
Message-ID: <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without
 CAP_SYS_RAWIO
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
Date: Tue, 12 Jun 2012 17:21:09 +0100
In-Reply-To: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 18:08 +0200, Paolo Bonzini wrote:
> Persistent reservations commands cannot be issued right now without
> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
> is a bit heavy-handed, allow these two commands.

Why is this heavy handed?  If you remove CAP_SYS_RAWIO, any userspace
process can send these, which would allow any user to completely disrupt
a SAN by injecting spurious reservations ... that doesn't look to be
terribly safe for an operating system running in a data centre.

James
 

