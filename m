Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2H0OKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:10:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41311 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2H0OKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
	<CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
Date: Mon, 27 Aug 2012 10:10:06 -0400
Message-ID: <CAEhu1-5sHQOTZ=KRxkpiAeBFC5BReR+svUGpp=9tk3drqJNg0A@mail.gmail.com>
Subject: Re: Possible mptsas regression post 3.5.0
From: John Drescher <drescherjm@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 3:34 PM, John Drescher <drescherjm@gmail.com> wrote:
> On Thu, Aug 23, 2012 at 1:34 PM, John Drescher <drescherjm@gmail.com> wrote:
>> Over the last few weeks I have done some reliability testing with
>> mdraid6 on a machine with 2 lsi mptsas controllers and 13 SATA I
>> drives. My testing involved physically hot removing a drive forcing
>> the raid to grab a spare and rebuild. This worked great for the 5 or
>> so times I did this on gentoo-sources-3.5.0 and lower. However any
>> attempt to do this on gentoo-sources-3.5.1 or even the 3.6-rc2 git
>> resulted in a total lockup of the array. I originally thought this was
>> a mdadm regression and posted about that last week here:
>>
>> https://lkml.org/lkml/2012/8/17/503
>>
>
> I have bisected the kernel a few times now and the problem was
> introduced between
> 3.5.0.00007-ged29dbd
> 3.5.0.00015-g4d9157e
>
> After the raid rebuilds again I will bisect again and see if I can
> narrow it down to the exact patch.
>

I have bisected it down to the following patch:

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[10f8d5b86743b33d841a175303e2bf67fd620f42] SCSI: fix hot unplug vs
async scan race

It appears this patch caused the bad behavior although I have not
tested that yet. I am rebuilding the array (takes ~2 hours) from the
previous good bisect.

-- 
John M. Drescher
