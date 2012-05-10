Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2EJUHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:07:06 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61704 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2EJUHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <4FAC1D09.1070004@wwwdotorg.org>
References: <4FAAB815.5040001@wwwdotorg.org> <4FAC1D09.1070004@wwwdotorg.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 10 May 2012 22:06:42 +0200
Message-ID: <CAPXgP11UqAZgfWXUrxi7VsYr_hoDgi=cP4yn5UJ5rdPU8i5_sA@mail.gmail.com>
Subject: Re: Regression due to 7ff9554 "printk: convert byte-buffer to
 variable-length record buffer"
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        William Douglas <william.douglas@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 9:54 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/09/2012 12:31 PM, Stephen Warren wrote:
>> For me, next-20120508 prints nothing when booted, and I think also
>> hangs. To solve this, I reverted:
>>
>> 7ff9554 printk: convert byte-buffer to variable-length record buffer
>>
>> In order to build, I also had to revert:
>>
>> c4e00da driver-core: extend dev_printk() to pass structured data
>>
>> Note: I'm running on an ARM system using a serial console, with
>> earlyprintk enabled.
>
> This issue still occurs in next-20120510.
>
> I've tracked it down to the assignment of msg->ts_nsec near the end of
> log_store(). If I comment this out, everything works. The problem is the
> assignment, not the call to local_clock():
>
> fails:
>        msg->ts_nsec = local_clock();
> fails:
>        msg->ts_nsec = 0;//local_clock();
> works:
>        //msg->ts_nsec = local_clock();

Weird.

What happens if you change it to:
  cpu_clock(logbuf_cpu);
?

If it works, the timestamps look ok?

Kay
