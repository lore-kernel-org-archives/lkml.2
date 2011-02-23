Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1BWRlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:41:35 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1BWRlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o0paoF5YdkjbBbyLSv3XghMcHZS1ODURkQeWab1uKuTdBiyCCeaLgls4aurVYQbuy4
         aSGGQT72pZW5hn0Vq+hw==
MIME-Version: 1.0
In-Reply-To: <20110222205634.GF29559@n2100.arm.linux.org.uk>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-6-git-send-email-ccross@android.com>
	<20110222205634.GF29559@n2100.arm.linux.org.uk>
Date: Wed, 23 Feb 2011 09:39:27 -0800
X-Google-Sender-Auth: IPjpVy0rN5McPgWH0HJEnA3OlaM
Message-ID: <AANLkTikiLwofnVB=f54MdqjAmrT2EvSxRryw3J7Jd5oC@mail.gmail.com>
Subject: Re: [PATCH 5/7] ARM: tegra: timer: Enable timer and rtc clocks
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-tegra@vger.kernel.org, konkers@android.com, mike@compulab.co.il,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:56 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Feb 21, 2011 at 06:39:50PM -0800, Colin Cross wrote:
>> +     struct clk *clk;
>>       unsigned long rate = clk_measure_input_freq();
>>       int ret;
>>
>> +     clk = clk_get_sys("timer", NULL);
>> +     BUG_ON(IS_ERR(clk));
>> +     clk_enable(clk);
>> +     clk_put(clk);
>> +
>> +     clk = clk_get_sys("rtc-tegra", NULL);
>> +     BUG_ON(IS_ERR(clk));
>> +     clk_enable(clk);
>> +     clk_put(clk);
>
> It's probably better to leave them get'd if you're continuing to use
> them and just forget the reference.
>

Good point, fixed.
