Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab0DXFCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 01:02:54 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:62782 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0DXFCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 01:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <201004231408.15885.dmitry.torokhov@gmail.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-9-git-send-email-arve@android.com>
	 <20100423135625.1e12d005.randy.dunlap@oracle.com>
	 <201004231408.15885.dmitry.torokhov@gmail.com>
Date: Fri, 23 Apr 2010 22:02:50 -0700
Message-ID: <z2wd6200be21004232202me5d59908y25bf9523fd62edce@mail.gmail.com>
Subject: Re: [PATCH 8/9] Input: Block suspend while event queue is not empty.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Sven Neumann <s.neumann@raumfeld.com>,
       Tero Saarni <tero.saarni@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>, Matthew Garrett <mjg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 2:08 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Friday 23 April 2010 01:56:25 pm Randy Dunlap wrote:
>> On Thu, 22 Apr 2010 18:08:57 -0700 Arve Hjønnevåg wrote:
>> > Add an ioctl, EVIOCSSUSPENDBLOCK, to enable a suspend_blocker that will
>> > block suspend while the event queue is not empty. This allows userspace
>> > code to process input events while the device appears to be asleep.
>>
>> All new ioctls need to be added to Documentation/ioctl/ioctl-number.txt,
>> please.
>
> I do not see the reason for it to be in the kernel still. Have a process
> that listens to all input devices (or subset of them), once events stop
> coming initiate suspend.
>

I think the document added by the first patch explains this. The
solution you propose above will ignore a wakeup key pressed right
after user space decides to initiate suspend.

-- 
Arve Hjønnevåg
