Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab0EDRe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:34:59 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:39516 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab0EDRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=HTza/wYrxa/xjvMok+qYJRTW6l7FvGPqHJKZmc+4RbNFrDOSpvP5hopjHD+sUYD97p
         3CAL+xogBAO8YKL52cDHloBYZ9yB+6/eyXb4+5TLEc7fV3HlL18CbSR/VZTFSPsJO1I5
         ITUOT3J8MKha+FAcbdDcG9jNG7n9g7VR8nmMI=
MIME-Version: 1.0
In-Reply-To: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
References: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
Date: Tue, 4 May 2010 12:34:52 -0500
X-Google-Sender-Auth: 64d292c9c371dbbe
Message-ID: <u2m58965d8a1005041034h72605714z46a1a1e06eccc86c@mail.gmail.com>
Subject: Re: Flash IO slow 1.5 MB/s
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 10:52 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> It really looks like there's a scheduling issue.  It seems as if the
> system is IO thrashing on the flash drive, and bounces all over the
> place in terms of performance.  Sometimes it's really low, like the
> 2.73M/s, and other times it's really fast, like the 28.86M/s.
> Although you can't see it there, there were times when rsync was
> registering 200kb/s.  None of them are "really" accurate, as
> everything is queued for writing, but the final results of 1.5M/s
> (calculated from the "real" time) is terrible.

I have a similar experience (posted to this list a few months ago)
with mounting a flash device (mobile phone) in USB mass storage mode.
When I/O scheduler for that device is CFQ, write performance is really
terrible. When I change the scheduler to deadline, performance is
several times better. In 2.6.32 pdflush was replaced and CFQ
performance saw a 4x increase but still far too slow.

CFQ in <=2.6.31: 450KB/sec
CFQ in >=2.6.32: 2MB/sec
Deadline in all: 17MB/sec

I didn't try anything with dirty_bytes.

FWIW :)
