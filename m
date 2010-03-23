Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CWNAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:00:12 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:55665 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0CWNAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qX9Cis2xdEuiVABTGLEF5KPOp0kXzgebpC1QK1HAiWG7C3J76ieCTWOh7MJie55TPb
         88YH+Qmfew8+HC0XcvYobp2AWY7Zt2+J8Iomz5mAwSmw7hwc/SgpofVg9pRcg266sGDE
         gokeiMf3fR1Y5hDVRAYvUt+bux6m1fHFEoIwQ=
MIME-Version: 1.0
In-Reply-To: <20100322144809.4d54bc7e.akpm@linux-foundation.org>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
	 <1268903124-10237-12-git-send-email-akinobu.mita@gmail.com>
	 <20100322144809.4d54bc7e.akpm@linux-foundation.org>
Date: Tue, 23 Mar 2010 22:00:09 +0900
Message-ID: <961aa3351003230600r45e4579ave945b2dd71d9e4a0@mail.gmail.com>
Subject: Re: [PATCH 12/12] add CPU notifier error injection module
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/23 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 18 Mar 2010 18:05:24 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> I used this module to test the series of modification to the
>> cpu notifiers code.
>>
>> Example1: inject CPU offline error (-1 == -EPERM)
>>
>>       # modprobe cpu-notifier-error-inject cpu_down_prepare_error=-1
>>       # echo 0 > /sys/devices/system/cpu/cpu1/online0
>>       bash: echo: write error: Operation not permitted
>>
>> Example2: inject CPU online error (-2 == -ENOENT)
>>
>>       # modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
>>       # echo 1 > /sys/devices/system/cpu/cpu1/online0
>>       bash: echo: write error: No such file or directory
>>
>> ...
>>
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -885,6 +885,18 @@ config LKDTM
>>       Documentation on how to use the module can be found in
>>       Documentation/fault-injection/provoke-crashes.txt
>>
>> +config CPU_NOTIFIER_ERROR_INJECT
>> +     tristate "CPU notifier error injection module"
>> +     depends on HOTPLUG_CPU && DEBUG_KERNEL
>> +     help
>> +       This option provides a kernel module that can be used to test
>> +       the error handling of the cpu notifiers
>> +
>> +       To compile this code as a module, choose M here: the module will
>> +       be called cpu-notify-inject.
>
> Should be "cpu-notifier-error-inject", yes?

Yes. Thanks for spotting and fixing.
And I had another typos in the above patch description:

>> Example1: inject CPU offline error (-1 == -EPERM)
>>
>>       # modprobe cpu-notifier-error-inject cpu_down_prepare_error=-1
>>       # echo 0 > /sys/devices/system/cpu/cpu1/online0

# echo 0 > /sys/devices/system/cpu/cpu1/online

(s/online0/online/)

>>       bash: echo: write error: Operation not permitted
>>
>> Example2: inject CPU online error (-2 == -ENOENT)
>>
>>       # modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
>>       # echo 1 > /sys/devices/system/cpu/cpu1/online0

Ditto.

>>       bash: echo: write error: No such file or directory
