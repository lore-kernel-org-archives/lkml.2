Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1JYPFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:05:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38683 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1JYPFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
References: <20111026005939.ad20ab7a2dacce216c69e821@canb.auug.org.au>
	<CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
Date: Tue, 25 Oct 2011 10:05:52 -0500
Message-ID: <CAH2r5mtkByKNPYN50ioRoS79sAR_rhShANcm9o-Qvo7S762VFg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected typo in proposed patch and merged to cifs-2.6.git

On Tue, Oct 25, 2011 at 9:51 AM, Steve French <smfrench@gmail.com> wrote:
> Am fixing it now.  Jeff missed a stub for the non-freezer case.
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index a155561..cd2d55b 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -202,6 +202,8 @@ static inline void set_freezable_with_signal(void) {}
>
>  #define wait_event_freezable_timeout(wq, condition, timeout)           \
>                wait_event_interruptible_timeout(wq, condition, timeout)
> +#define #define wait_event_freezekillable(wq, condition)               \
> +               wait_event_killable(wq, condition)
>
>
> On Tue, Oct 25, 2011 at 8:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the cifs tree, today's linux-next build (powerpc
>> iseries_defconfig) failed like this:
>>
>> fs/cifs/transport.c: In function 'wait_for_response':
>> fs/cifs/transport.c:328: error: implicit declaration of function 'wait_event_freezekillable'
>>
>> Caused by commit f06ac72e9291 ("cifs, freezer: add
>> wait_event_freezekillable and have cifs use it").  In this config,
>> CONFIG_FREEZER is not set.
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>> http://www.canb.auug.org.au/~sfr/
>>
>
>
>
> --
> Thanks,
>
> Steve
>



-- 
Thanks,

Steve
