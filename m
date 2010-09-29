Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0I2Lww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0I2Lwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:52:50 -0400
Message-ID: <4CA3288F.4030200@redhat.com>
Date: Wed, 29 Sep 2010 13:52:47 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix numbering in /proc/locks
References: <4CA0B4A5.1090701@redhat.com> <4CA0B743.2050801@parallels.com> <4CA32626.8040700@redhat.com> <4CA32677.2020203@parallels.com>
In-Reply-To: <4CA32677.2020203@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 01:43 PM, Pavel Emelyanov wrote:
>> Good point. My implementation is definitely wrong. But I'm afraid that
>> moving the increment in locks_next() won't help either. It will fail when
>> a program do something more than just read the file sequentially (use
>> of lseek() for instance). We need a better way to keep track of the
>> current position in the list.
> 
> The seq files core implementation knows about the lseek and
> calls the seq_ops callbacks properly.
> 

Yes, but if read a few lines and then lseek() back. I'm afraid it will call
a few more locks_next() function and thus increase the counter again.
