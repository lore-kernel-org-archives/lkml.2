Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab2BWVBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:01:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2BWVBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:01:08 -0500
Date: Thu, 23 Feb 2012 13:01:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: dave@gnu.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Matthew Wilcox <matthew@wil.cx>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] locks: new procfs lockinfo
Message-Id: <20120223130106.8d976093.akpm@linux-foundation.org>
In-Reply-To: <m1r4xmz8n0.fsf@fess.ebiederm.org>
References: <1329737454.3058.3.camel@offbook>
	<m1r4xmz8n0.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012 16:38:27 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Davidlohr Bueso <dave@gnu.org> writes:
> 
> > From: Davidlohr Bueso <dave@gnu.org>
> >
> > Based on our previous discussion https://lkml.org/lkml/2012/2/10/462 we came to
> > agree on deprecating the current /proc/locks in favor of a more extensible interface.
> > The new /proc/lockinfo file exports similar information - except instead of maj:min the
> > device name is shown - and entries are formated like those in /proc/cpuinfo, allowing us
> > to add new entries without breaking userspace.
> 
> You can't know the device name, attempt to say what you don't know seems
> very dangerous.  It may be reasonable to simply give the deivce number
> and not split the device number into major/minor any more and I am
> concerned about reality.

I don't think we've ever been told any *reason* for switching from
major:minor to device-name.  This is a problem.

And yes, major:minor reliably and uniquely identifies the device.  I'm
not sure that the human-readable string which is largely a convenience
thing is as reliable as this.

