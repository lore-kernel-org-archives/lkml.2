Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2JPWpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:45:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45197 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2JPWpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121016071136.GB5172@kroah.com>
References: <20121015235836.GA3214@kroah.com>
	<1350347562-32643-1-git-send-email-arve@android.com>
	<20121016071136.GB5172@kroah.com>
Date: Tue, 16 Oct 2012 15:45:20 -0700
Message-ID: <CAMP5XgfVPeN8CRwKxeTv6fL8M0MXV56R+GrWw88caVZrQfu+Vg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: android: binder: Fix memory leak on
 thread/process exit
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 15, 2012 at 05:32:41PM -0700, Arve Hjønnevåg wrote:
>> If a thread or process exited while a reply, one-way transaction or
>> death notification was pending, the struct holding the pending work
>> was leaked.
>>
>> Change-Id: I2eaafaba1c0ecda3ec0872d449dc16d0721c21e7
>
> What is this field?  Please don't include this in kernel patches, it
> forces me to edit the patch by hand :(
>

It is a tag generated a git hook to uniquely identify a change through
multiple revisions of that change. If the tag does not already exist
the hook adds it. I removed it from the reposted patches as you
requested, but have you considered leaving it in? It is a useful
search token both for finding different revisions of a patch and for
finding which branch a change has been cherry-picked into.

> Also, this should go to older kernels, right?

It can, but the leak is relatively slow so I don't think it is
critical. I looked at one device that had been running for a while and
it had leaked around 16k per month.

-- 
Arve Hjønnevåg
