Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2FGXif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:38:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59060 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2FGXid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120607225446.GK19839@thunk.org>
References: <471046920.20120604234941@eikelenboom.it>
	<20120605000356.GM29466@outflux.net>
	<1018371644.20120605224154@eikelenboom.it>
	<20120605210806.GB7182@thunk.org>
	<1883708187.20120606090126@eikelenboom.it>
	<CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
	<1482118647.20120606164012@eikelenboom.it>
	<20120607042756.GA30776@thunk.org>
	<20120607222729.GI6938@tux1.beaverton.ibm.com>
	<CAGXu5jKmBkfvuSR7q47-Ac57dVZynz_JkYXiA_-aXaGQiR_C4g@mail.gmail.com>
	<20120607225446.GK19839@thunk.org>
Date: Thu, 7 Jun 2012 16:38:31 -0700
X-Google-Sender-Auth: l_8Qri6Hp31fGD8D-1i811V7dXc
Message-ID: <CAGXu5j+mF1jnMXDT-Vpb6T5s34XgTRTeDOdyoXYy_RwNfaUn6w@mail.gmail.com>
Subject: Re: [dm-devel] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741:
 group 1904, 32254 clusters in bitmap, 32258 in gd
From: Kees Cook <keescook@chromium.org>
To: "Ted Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        djwong@us.ibm.com, Sander Eikelenboom <linux@eikelenboom.it>,
        Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 3:54 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 07, 2012 at 03:40:40PM -0700, Kees Cook wrote:
>>
>> FWIW, I was building the filesystem that triggered this as ext4:
>>
>>   mkfs.ext4 -T default -m 0 -O ^huge_file,^flex_bg -E
>> discard,lazy_itable_init /dev/mapper/...
>
> Ouy of curiosity, was there a reason you chose those particular file
> system parameters?  It's a surprising set, because if you're starting
> with a fresh file system, enabling flex_bg produces a more optimal
> file system layout.

The intent of this was to create a small (64M) initial filesystem as
fast as possible that could be resized (to 3G) on the fly later. (The
performance of the filesystem did not need to be optimized, just the
speed of creation so that the create+mount would happen as fast as
possible, to unblock things waiting for this filesystem to exist.)

In the more common situation, it was built also with:
 -b 4096 ... -E ...,resize=MMM ... [device] NNN
where MMM > NNN. And an online resize would be started a bit after it
was created, growing it up to MMM.

-Kees

-- 
Kees Cook
Chrome OS Security
