Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab2AJTZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:25:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58050 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2AJTZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:25:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120110121459.6b358afe6052810e91dfdd47@canb.auug.org.au>
References: <CA+8MBbKKTmZ2fD-j0xnQuxDh9jBO8jfV=gjP2cVvuPZg4r42+Q@mail.gmail.com>
	<20120110121459.6b358afe6052810e91dfdd47@canb.auug.org.au>
Date: Tue, 10 Jan 2012 11:25:00 -0800
Message-ID: <CA+8MBb+=dQb9LE=pDbOw7DBh0Tr=rp4cTstxwQGWGDOguvMpaw@mail.gmail.com>
Subject: Re: more PID churn during boot?
From: Tony Luck <tony.luck@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 5:14 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> while the 2012 editions print:
>>
>> udevd (341): /proc/341/oom_adj is deprecated, please use
>> /proc/341/oom_score_adj instead.

Ok - not a kernel problem. Building old kernels (that used to not have this
much churn) while checking for the start point for a bisect started showing
the same churn.

I tracked the start of the problem to when I updated my build machine
on jan 3rd - and it's now throwing a new version of udevd[*] into the initrd
that I throw at my test machine.
Probably a bunch of other initrd components are new versions too.

-Tony

[1] Builds since Jan 3rd all have this extra line in dmesg log:
udev: starting version 147
