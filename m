Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab1KJN24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:28:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51231 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1KJN2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:28:55 -0500
Message-ID: <4EBBD190.2020404@gmail.com>
Date: Thu, 10 Nov 2011 21:28:48 +0800
From: Xiao Guangrong <xiao.grong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com> <4E91926D.8060206@redhat.com> <4E91A3AA.1000309@redhat.com> <4E940018.1010908@cn.fujitsu.com> <4EB3AD54.9050605@gmail.com> <4EB6A958.9030007@redhat.com>
In-Reply-To: <4EB6A958.9030007@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080108020405030807050109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108020405030807050109
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/06/2011 11:35 PM, Avi Kivity wrote:
> On 11/04/2011 11:16 AM, Xiao Guangrong wrote:
>>
>> I have done kernbench tests several times on my desktop, but it shows
>> very well:
>>
>> before patchset:
>> real 212.27
>> real 213.47
>> real 204.99
>> real 200.58
>> real 199.99
>> real 199.94
>> real 201.51
>> real 199.83
>> real 198.19
>> real 205.13
>>
>> after patchset:
>> real 199.90
>> real 201.89
>> real 194.54
>> real 188.71
>> real 185.75
>> real 187.70
>> real 188.99
>> real 188.53
>> real 186.29
>> real 188.25
>>
>> I will test it on our server using kvm-autotest, could you share me
>> your config file please?
>
>
> # Copy this file to tests.cfg and edit it.
> #
> # This file contains the test set definitions. Define your test sets here.
>

Thanks Avi!

I have tested RHEL.6.1 setup/boot/reboot/shutdown and the complete output of 
scan_results.py is attached.

The result shows the performance is improved:
before:			After:
570			529
555			538
552			531
546			528
553			559
553			527
550			523
553			533
547			538
550			526

How do you think about it? :)

--------------080108020405030807050109
Content-Type: application/x-bzip;
 name="result.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="result.tar.bz2"

QlpoOTFBWSZTWUPcrW4AD4j/hPyQVEBA4//wBuacIP9n3qAAAIAIUAP+HIBQAAOYACYAAmAA
AAABzAATAAEwAAAAAGmpom1NQNGowBAaZGABMQYcwAEwABMAAAAAApUiaTyEJtJPI01J5T1N
o1B6jTT1HpPU/Ip8vq+/e/Dw727Rv6c1MalHcTFgT1PXt4dZi3cfHDnid5OAxYpYKuBM2RMG
RMiUy5k3E/cn2J/Dq93X7tu7q9Ho1357abba7bfd2o5FXuJ2FXosUlPKwSJ9QQUgIP4BBUos
OtUWKFmmptEMRBYrS57QnjCcq8l6uj8AIAjQkSCSkxnJIZYiREi8hxDEGTw7Lcwya4yxlsy3
bs9/aTyJ4idomCcxV4E7CZBP0Jo0TGEzJgn0CZFX8SbyeJSMycBPzJ7yZk95PiJzCfIJ+ATI
nkT1hMirr3kw6SZEyJs9OjwLN6/VjZxTQX7ft3PniuOLXXO12xwfj48uhlo6wmrdhpwssmPa
xuvGf99/J1acXN5hNUz45GWm/GeXBixqyadeXXizw3+YTA46saujbopu7Oim5x3N1oSwZSFb
1jUewIYyQFCEAJQIqFERxRhCEoG/mE2Cb2rixzYa2Nbbg6MteLlvrq06bHLlcGnDHDlsM6Jo
0z3GLcuwn/CL5hP7k4E9s/XBimGMDD9WMTLJkWGPAJ0k/0E37EXzIsu8J8yZfkTiT4CZ/EmL
8/5VP6EwJ5Ez9JOJPc+wTIn+wnvJ8CYE3k44IuJNicSdBMyfD+ZME+JNAnWJ55ScPpsE+ons
JtU4BOknsJ0ky8/kRdoTodxPImxO8nyCak9VUNwT9ycAmAn3JuJyJmTyJsTiTkTmRYO4TPeU
7yfQE6rhu7Cbef/vEm9sTweDsJmTBPYT0hOJPaE1FXrJvuBPAJupOspqJ6qTFT8SYJ0E0CcS
eneTtKt4TMJipkTBOkmgn2vuTiTUJzpf/F3JFOFCQQ9ytbg=
--------------080108020405030807050109--
