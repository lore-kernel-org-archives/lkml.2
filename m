Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2JGX4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:56:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2JGXz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:55:58 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1349645172.16173.152.camel@deadeye.wl.decadent.org.uk>
References: <20120928182957.993484211@linuxfoundation.org> <20120928183018.599659336@linuxfoundation.org> <1349645172.16173.152.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [ 174/262] x86, avx: dont use avx instructions with "noxsave" boot param
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 08 Oct 2012 07:55:31 +0800
To: Ben Hutchings <ben@decadent.org.uk>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <c43c49d3-cf80-49c4-b41e-12db7ce90c24@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userland should use a different query mechanism.  On the other hand, it will not hurt either.  On pre-xsave kernels AVX is a non-option.

Ben Hutchings <ben@decadent.org.uk> wrote:

>On Fri, 2012-09-28 at 11:51 -0700, Greg Kroah-Hartman wrote:
>> From: Greg KH <gregkh@linuxfoundation.org>
>> 
>> 3.5-stable review patch.  If anyone has any objections, please let me
>know.
>> 
>> ------------------
>> 
>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>> 
>> commit c6fd893da927c6cefb2ece22402765379921a834 upstream.
>> 
>> Clear AVX, AVX2 features along with clearing XSAVE feature bits,
>> as part of the parsing "noxsave" parameter.
>> 
>> Fixes the kernel boot panic with "noxsave" boot parameter.
>> 
>> We could have checked cpu_has_osxsave along with cpu_has_avx etc, but
>Peter
>> mentioned clearing the feature bits will be better for uses like
>> static_cpu_has() etc.
>
>This was marked as needed for 3.5 only - presumably because the kernel
>wasn't using AVX before this - but don't we also need to clear these
>bits even in earlier versions so userland knows not to use it?
>
>Ben.
>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>> Link:
>http://lkml.kernel.org/r/1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> ---
>>  arch/x86/kernel/cpu/common.c |    2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -144,6 +144,8 @@ static int __init x86_xsave_setup(char *
>>  {
>>  	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
>>  	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
>> +	setup_clear_cpu_cap(X86_FEATURE_AVX);
>> +	setup_clear_cpu_cap(X86_FEATURE_AVX2);
>>  	return 1;
>>  }
>>  __setup("noxsave", x86_xsave_setup);

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
