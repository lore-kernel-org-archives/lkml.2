Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0JRGXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:23:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64486 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab0JRGXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:23:46 -0400
Message-ID: <4CBBE7FB.2060303@cn.fujitsu.com>
Date: Mon, 18 Oct 2010 14:23:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
References: <4CAEC81C.1070108@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com> <4CAEDE0D.2040009@cn.fujitsu.com> <4CB62543.7000605@zytor.com> <C10D3FB0CD45994C8A51FEC1227CE22F15CC203E71@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F15CC203E71@shsmsx502.ccr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------090509090704040707070200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090509090704040707070200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On Fri, 15 Oct 2010 03:43:53 +0800, Ma, Ling wrote:
> Attachment includes memcpy-kernel.c(cc -O2 memcpy-kernel.c -o memcpy-kernel),
> and unaligned test cases on Atom.

I have tested on my Core2 Duo machine with your benchmark tool. Attachment is the
test result. But the result is different with yours on Atom, It seems the performance
is better with this patch.

According to these two different result, maybe we need optimize memcpy() by CPU
model.

Thanks
Miao

>
> Thanks
> Ling
>
> -----Original Message-----
> From: Ma, Ling
> Sent: Thursday, October 14, 2010 9:14 AM
> To: 'H. Peter Anvin'; miaox@cn.fujitsu.com
> Cc: Ingo Molnar; Andi Kleen; Thomas Gleixner; Zhao, Yakui; Linux Kernel
> Subject: RE: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy() for unaligned copy
>
> Sure, I will post benchmark tool and benchmark on Atom 64bit soon.
>
> Thanks
> Ling
>
> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Thursday, October 14, 2010 5:32 AM
> To: miaox@cn.fujitsu.com
> Cc: Ma, Ling; Ingo Molnar; Andi Kleen; Thomas Gleixner; Zhao, Yakui; Linux Kernel
> Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy() for unaligned copy
>
> On 10/08/2010 02:02 AM, Miao Xie wrote:
>> On Fri, 8 Oct 2010 15:42:45 +0800, Ma, Ling wrote:
>>> Could you please give us full address for each comparison result,we will do some tests on my machine.
>>> For unaligned cases older cpus will crossing cache line and slow down caused by load and store, but for nhm, no necessary to care about it.
>>> By the way in kernel 64bit mode, our access mode should be around 8byte aligned.
>>
>> Would you need my benchmark tool? I think it is helpful for your test.
>>
>
> If you could post the benchmark tool that would be great.
>
> 	-hpa


--------------090509090704040707070200
Content-Type: text/plain;
 name="memcpy-Core2-Duo-CPU-unaligned-result"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="memcpy-Core2-Duo-CPU-unaligned-result"

                       	memcpy_orig	memcpy_new
LAT: Len    1, alignment  0/ 0:	40	40
LAT: Len    1, alignment  0/ 0:	40	40
LAT: Len    2, alignment  1/ 0:	40	40
LAT: Len    2, alignment  0/ 1:	50	50
LAT: Len    4, alignment  2/ 0:	40	40
LAT: Len    4, alignment  0/ 2:	40	40
LAT: Len    8, alignment  3/ 0:	40	40
LAT: Len    8, alignment  0/ 3:	40	40
LAT: Len   16, alignment  4/ 0:	40	40
LAT: Len   16, alignment  0/ 4:	40	40
LAT: Len   32, alignment  5/ 0:	40	40
LAT: Len   32, alignment  0/ 5:	40	40
LAT: Len   64, alignment  6/ 0:	60	50
LAT: Len   64, alignment  0/ 6:	60	60
LAT: Len  128, alignment  7/ 0:	70	70
LAT: Len  128, alignment  0/ 7:	80	80
LAT: Len  256, alignment  8/ 0:	80	70
LAT: Len  256, alignment  0/ 8:	80	80
LAT: Len  512, alignment  9/ 0:	190	260
LAT: Len  512, alignment  0/ 9:	190	220
LAT: Len 1024, alignment 10/ 0:	340	490
LAT: Len 1024, alignment  0/10:	340	440
LAT: Len 2048, alignment 11/ 0:	650	940
LAT: Len 2048, alignment  0/11:	620	870
LAT: Len 4096, alignment 12/ 0:	1280	2140
LAT: Len 4096, alignment  0/12:	1410	1750
LAT: Len    0, alignment  0/ 0:	40	40
LAT: Len    0, alignment  0/ 0:	40	40
LAT: Len    1, alignment  1/ 0:	40	40
LAT: Len    1, alignment  0/ 1:	40	40
LAT: Len    2, alignment  2/ 0:	40	40
LAT: Len    2, alignment  0/ 2:	40	40
LAT: Len    3, alignment  3/ 0:	40	40
LAT: Len    3, alignment  0/ 3:	40	40
LAT: Len    4, alignment  4/ 0:	40	40
LAT: Len    4, alignment  0/ 4:	40	40
LAT: Len    5, alignment  5/ 0:	40	40
LAT: Len    5, alignment  0/ 5:	40	40
LAT: Len    6, alignment  6/ 0:	40	40
LAT: Len    6, alignment  0/ 6:	40	40
LAT: Len    7, alignment  7/ 0:	40	40
LAT: Len    7, alignment  0/ 7:	40	40
LAT: Len    8, alignment  8/ 0:	40	40
LAT: Len    8, alignment  0/ 8:	40	40
LAT: Len    9, alignment  9/ 0:	40	40
LAT: Len    9, alignment  0/ 9:	40	40
LAT: Len   10, alignment 10/ 0:	40	40
LAT: Len   10, alignment  0/10:	40	40
LAT: Len   11, alignment 11/ 0:	40	40
LAT: Len   11, alignment  0/11:	40	40
LAT: Len   12, alignment 12/ 0:	40	40
LAT: Len   12, alignment  0/12:	40	40
LAT: Len   13, alignment 13/ 0:	40	40
LAT: Len   13, alignment  0/13:	40	40
LAT: Len   14, alignment 14/ 0:	40	40
LAT: Len   14, alignment  0/14:	40	40
LAT: Len   15, alignment 15/ 0:	40	40
LAT: Len   15, alignment  0/15:	40	40
LAT: Len   16, alignment 16/ 0:	40	40
LAT: Len   16, alignment  0/16:	40	40
LAT: Len   17, alignment 17/ 0:	40	40
LAT: Len   17, alignment  0/17:	40	40
LAT: Len   18, alignment 18/ 0:	40	40
LAT: Len   18, alignment  0/18:	40	40
LAT: Len   19, alignment 19/ 0:	40	40
LAT: Len   19, alignment  0/19:	40	40
LAT: Len   20, alignment 20/ 0:	40	40
LAT: Len   20, alignment  0/20:	40	40
LAT: Len   21, alignment 21/ 0:	40	40
LAT: Len   21, alignment  0/21:	40	40
LAT: Len   22, alignment 22/ 0:	40	40
LAT: Len   22, alignment  0/22:	40	40
LAT: Len   23, alignment 23/ 0:	40	40
LAT: Len   23, alignment  0/23:	40	40
LAT: Len   24, alignment 24/ 0:	40	40
LAT: Len   24, alignment  0/24:	40	40
LAT: Len   25, alignment 25/ 0:	40	40
LAT: Len   25, alignment  0/25:	40	40
LAT: Len   26, alignment 26/ 0:	40	40
LAT: Len   26, alignment  0/26:	40	40
LAT: Len   27, alignment 27/ 0:	40	40
LAT: Len   27, alignment  0/27:	40	40
LAT: Len   28, alignment 28/ 0:	40	40
LAT: Len   28, alignment  0/28:	40	40
LAT: Len   29, alignment 29/ 0:	40	40
LAT: Len   29, alignment  0/29:	40	40
LAT: Len   30, alignment 30/ 0:	40	40
LAT: Len   30, alignment  0/30:	40	40
LAT: Len   31, alignment 31/ 0:	40	40
LAT: Len   31, alignment  0/31:	40	40
LAT: Len    0, alignment  0/ 8:	40	40
LAT: Len    0, alignment  1/ 8:	40	40
LAT: Len    0, alignment  4/ 8:	40	40
LAT: Len    1, alignment  0/ 8:	40	40
LAT: Len    1, alignment  1/ 8:	40	40
LAT: Len    1, alignment  4/ 8:	40	40
LAT: Len    2, alignment  0/ 8:	40	40
LAT: Len    2, alignment  1/ 8:	40	40
LAT: Len    2, alignment  4/ 8:	40	40
LAT: Len    3, alignment  0/ 8:	40	40
LAT: Len    3, alignment  1/ 8:	40	40
LAT: Len    3, alignment  4/ 8:	40	40
LAT: Len    4, alignment  0/ 8:	40	40
LAT: Len    4, alignment  1/ 8:	40	40
LAT: Len    4, alignment  4/ 8:	40	40
LAT: Len    5, alignment  0/ 8:	40	40
LAT: Len    5, alignment  1/ 8:	40	40
LAT: Len    5, alignment  4/ 8:	40	40
LAT: Len    6, alignment  0/ 8:	40	40
LAT: Len    6, alignment  1/ 8:	40	40
LAT: Len    6, alignment  4/ 8:	40	40
LAT: Len    7, alignment  0/ 8:	40	40
LAT: Len    7, alignment  1/ 8:	40	40
LAT: Len    7, alignment  4/ 8:	40	40
LAT: Len    8, alignment  0/ 8:	40	40
LAT: Len    8, alignment  1/ 8:	40	40
LAT: Len    8, alignment  4/ 8:	40	40
LAT: Len    9, alignment  0/ 8:	40	40
LAT: Len    9, alignment  1/ 8:	40	40
LAT: Len    9, alignment  4/ 8:	40	40
LAT: Len   10, alignment  0/ 8:	40	40
LAT: Len   10, alignment  1/ 8:	40	40
LAT: Len   10, alignment  4/ 8:	40	40
LAT: Len   11, alignment  0/ 8:	40	40
LAT: Len   11, alignment  1/ 8:	40	40
LAT: Len   11, alignment  4/ 8:	40	40
LAT: Len   12, alignment  0/ 8:	40	40
LAT: Len   12, alignment  1/ 8:	40	40
LAT: Len   12, alignment  4/ 8:	40	40
LAT: Len   13, alignment  0/ 8:	40	40
LAT: Len   13, alignment  1/ 8:	40	40
LAT: Len   13, alignment  4/ 8:	40	40
LAT: Len   14, alignment  0/ 8:	40	40
LAT: Len   14, alignment  1/ 8:	40	40
LAT: Len   14, alignment  4/ 8:	40	40
LAT: Len   15, alignment  0/ 8:	40	40
LAT: Len   15, alignment  1/ 8:	40	40
LAT: Len   15, alignment  4/ 8:	40	40
LAT: Len   16, alignment  0/ 8:	40	40
LAT: Len   16, alignment  1/ 8:	40	40
LAT: Len   16, alignment  4/ 8:	40	40
LAT: Len   17, alignment  0/ 8:	40	40
LAT: Len   17, alignment  1/ 8:	40	40
LAT: Len   17, alignment  4/ 8:	40	40
LAT: Len   18, alignment  0/ 8:	40	40
LAT: Len   18, alignment  1/ 8:	40	40
LAT: Len   18, alignment  4/ 8:	40	40
LAT: Len   19, alignment  0/ 8:	40	40
LAT: Len   19, alignment  1/ 8:	40	40
LAT: Len   19, alignment  4/ 8:	40	40
LAT: Len   20, alignment  0/ 8:	40	40
LAT: Len   20, alignment  1/ 8:	40	40
LAT: Len   20, alignment  4/ 8:	40	40
LAT: Len   21, alignment  0/ 8:	40	40
LAT: Len   21, alignment  1/ 8:	40	40
LAT: Len   21, alignment  4/ 8:	40	40
LAT: Len   22, alignment  0/ 8:	40	40
LAT: Len   22, alignment  1/ 8:	40	40
LAT: Len   22, alignment  4/ 8:	40	40
LAT: Len   23, alignment  0/ 8:	40	40
LAT: Len   23, alignment  1/ 8:	40	40
LAT: Len   23, alignment  4/ 8:	40	40
LAT: Len   24, alignment  0/ 8:	40	40
LAT: Len   24, alignment  1/ 8:	40	40
LAT: Len   24, alignment  4/ 8:	40	40
LAT: Len   25, alignment  0/ 8:	40	40
LAT: Len   25, alignment  1/ 8:	40	40
LAT: Len   25, alignment  4/ 8:	40	40
LAT: Len   26, alignment  0/ 8:	40	40
LAT: Len   26, alignment  1/ 8:	40	40
LAT: Len   26, alignment  4/ 8:	40	40
LAT: Len   27, alignment  0/ 8:	40	40
LAT: Len   27, alignment  1/ 8:	40	40
LAT: Len   27, alignment  4/ 8:	40	40
LAT: Len   28, alignment  0/ 8:	40	40
LAT: Len   28, alignment  1/ 8:	40	40
LAT: Len   28, alignment  4/ 8:	40	40
LAT: Len   29, alignment  0/ 8:	40	40
LAT: Len   29, alignment  1/ 8:	40	40
LAT: Len   29, alignment  4/ 8:	40	40
LAT: Len   30, alignment  0/ 8:	40	40
LAT: Len   30, alignment  1/ 8:	40	40
LAT: Len   30, alignment  4/ 8:	40	40
LAT: Len   31, alignment  0/ 8:	40	40
LAT: Len   31, alignment  1/ 8:	40	40
LAT: Len   31, alignment  4/ 8:	40	40
LAT: Len   32, alignment  0/ 8:	40	40
LAT: Len   32, alignment  1/ 8:	40	40
LAT: Len   32, alignment  4/ 8:	40	40
LAT: Len   33, alignment  0/ 8:	50	40
LAT: Len   33, alignment  1/ 8:	50	40
LAT: Len   33, alignment  4/ 8:	50	40
LAT: Len   34, alignment  0/ 8:	50	40
LAT: Len   34, alignment  1/ 8:	50	40
LAT: Len   34, alignment  4/ 8:	50	40
LAT: Len   35, alignment  0/ 8:	50	40
LAT: Len   35, alignment  1/ 8:	50	40
LAT: Len   35, alignment  4/ 8:	50	40
LAT: Len   36, alignment  0/ 8:	40	40
LAT: Len   36, alignment  1/ 8:	40	40
LAT: Len   36, alignment  4/ 8:	40	40
LAT: Len   37, alignment  0/ 8:	40	40
LAT: Len   37, alignment  1/ 8:	40	40
LAT: Len   37, alignment  4/ 8:	50	40
LAT: Len   38, alignment  0/ 8:	40	40
LAT: Len   38, alignment  1/ 8:	40	40
LAT: Len   38, alignment  4/ 8:	50	40
LAT: Len   39, alignment  0/ 8:	40	40
LAT: Len   39, alignment  1/ 8:	40	40
LAT: Len   39, alignment  4/ 8:	50	40
LAT: Len   40, alignment  0/ 8:	40	40
LAT: Len   40, alignment  1/ 8:	40	50
LAT: Len   40, alignment  4/ 8:	40	50
LAT: Len   41, alignment  0/ 8:	40	40
LAT: Len   41, alignment  1/ 8:	40	50
LAT: Len   41, alignment  4/ 8:	40	50
LAT: Len   42, alignment  0/ 8:	40	40
LAT: Len   42, alignment  1/ 8:	40	50
LAT: Len   42, alignment  4/ 8:	40	50
LAT: Len   43, alignment  0/ 8:	40	40
LAT: Len   43, alignment  1/ 8:	40	50
LAT: Len   43, alignment  4/ 8:	40	50
LAT: Len   44, alignment  0/ 8:	40	40
LAT: Len   44, alignment  1/ 8:	40	50
LAT: Len   44, alignment  4/ 8:	40	50
LAT: Len   45, alignment  0/ 8:	40	40
LAT: Len   45, alignment  1/ 8:	40	50
LAT: Len   45, alignment  4/ 8:	50	50
LAT: Len   46, alignment  0/ 8:	40	40
LAT: Len   46, alignment  1/ 8:	40	50
LAT: Len   46, alignment  4/ 8:	50	50
LAT: Len   47, alignment  0/ 8:	40	40
LAT: Len   47, alignment  1/ 8:	40	50
LAT: Len   47, alignment  4/ 8:	50	50
LAT: Len   48, alignment  3/ 0:	40	40
LAT: Len   48, alignment  0/ 3:	40	50
LAT: Len   80, alignment  5/ 0:	60	60
LAT: Len   80, alignment  0/ 5:	60	70
LAT: Len   96, alignment  6/ 0:	60	60
LAT: Len   96, alignment  0/ 6:	60	70
LAT: Len  112, alignment  7/ 0:	70	60
LAT: Len  112, alignment  0/ 7:	60	80
LAT: Len  144, alignment  9/ 0:	80	90
LAT: Len  144, alignment  0/ 9:	90	90
LAT: Len  160, alignment 10/ 0:	80	90
LAT: Len  160, alignment  0/10:	80	90
LAT: Len  176, alignment 11/ 0:	90	100
LAT: Len  176, alignment  0/11:	90	100
LAT: Len  192, alignment 12/ 0:	90	120
LAT: Len  192, alignment  0/12:	100	90
LAT: Len  208, alignment 13/ 0:	100	120
LAT: Len  208, alignment  0/13:	110	110
LAT: Len  224, alignment 14/ 0:	100	120
LAT: Len  224, alignment  0/14:	110	110
LAT: Len  240, alignment 15/ 0:	100	130
LAT: Len  240, alignment  0/15:	110	130
LAT: Len  272, alignment 17/ 0:	110	150
LAT: Len  272, alignment  0/17:	110	140
LAT: Len  288, alignment 18/ 0:	120	150
LAT: Len  288, alignment  0/18:	130	140
LAT: Len  304, alignment 19/ 0:	140	180
LAT: Len  304, alignment  0/19:	130	180
LAT: Len  320, alignment 20/ 0:	140	180
LAT: Len  320, alignment  0/20:	150	160
LAT: Len  336, alignment 21/ 0:	150	180
LAT: Len  336, alignment  0/21:	140	170
LAT: Len  352, alignment 22/ 0:	140	180
LAT: Len  352, alignment  0/22:	150	170
LAT: Len  368, alignment 23/ 0:	160	210
LAT: Len  368, alignment  0/23:	140	200
LAT: Len  384, alignment 24/ 0:	90	90
LAT: Len  384, alignment  0/24:	100	90
LAT: Len  400, alignment 25/ 0:	150	190
LAT: Len  400, alignment  0/25:	150	200
LAT: Len  416, alignment 26/ 0:	150	190
LAT: Len  416, alignment  0/26:	190	190
LAT: Len  432, alignment 27/ 0:	180	220
LAT: Len  432, alignment  0/27:	170	210
LAT: Len  448, alignment 28/ 0:	160	220
LAT: Len  448, alignment  0/28:	210	200
LAT: Len  464, alignment 29/ 0:	170	220
LAT: Len  464, alignment  0/29:	170	230
LAT: Len  480, alignment 30/ 0:	170	220
LAT: Len  480, alignment  0/30:	220	220
LAT: Len  496, alignment 31/ 0:	200	240
LAT: Len  496, alignment  0/31:	180	240

--------------090509090704040707070200--
