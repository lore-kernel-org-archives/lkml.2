Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1HBNO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:14:26 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:49799 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1HBNOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:14:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDyW9aTKJzUrVdANjK5mG0DW9+R4GRCG5_oaaX8RTEezwg@mail.gmail.com>
References: <CAPweEDyUJZ8ggm0zhMquKNM6Kd-ejjUXrCMR3TnJngukSHAFkw@mail.gmail.com>
	<CAPweEDyW9aTKJzUrVdANjK5mG0DW9+R4GRCG5_oaaX8RTEezwg@mail.gmail.com>
Date: Tue, 2 Aug 2011 14:14:19 +0100
Message-ID: <CAPweEDxo1_KaHSmqjg6YJz688g0=wsb4n3fZ0YRiUK_NWt_Kww@mail.gmail.com>
Subject: Re: corrupted ext4 1000gb filesystem (2.6.32, debian stable)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 1:15 AM, Luke Kenneth Casson Leighton
<luke.leighton@gmail.com> wrote:

> ok, um... i have a bit more information about this situation, to
> report.  two consecutive runs of fsck.ext4, and the filesystem still
> reports errors after the first run "corrected" all errors. i'd say
> that was a bit serious.

 rright - apologies but i've located the likely source of the problem
- e2fsck.  the issue is that the bitmaps for the 3-way RAID1 mirror
were corrupted.  thus, the filesystem would be fixed by e2fsck, only
to be completely buggered up by picking wildly inappropriate sections
of the drive... that presumably by either bad luck or by a powercut
and writes occurring at the time happened to be on inode blocks.

 whilst it is not entirely possible, due to this being a complex
interdependent set of empirical observations, to rule out ext4, i
believe it's safe to say that ext4 is not a high candidate, and i
apologise for taking up peoples' time.  now all i can hope for is that
the data isn't completely buggered.. :)

l.
