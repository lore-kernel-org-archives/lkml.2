Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0I2LoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:44:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2069 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0I2LoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:44:11 -0400
Message-ID: <4CA32677.2020203@parallels.com>
Date: Wed, 29 Sep 2010 15:43:51 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix numbering in /proc/locks
References: <4CA0B4A5.1090701@redhat.com> <4CA0B743.2050801@parallels.com> <4CA32626.8040700@redhat.com>
In-Reply-To: <4CA32626.8040700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good point. My implementation is definitely wrong. But I'm afraid that
> moving the increment in locks_next() won't help either. It will fail when
> a program do something more than just read the file sequentially (use
> of lseek() for instance). We need a better way to keep track of the
> current position in the list.

The seq files core implementation knows about the lseek and
calls the seq_ops callbacks properly.

> Thanks,
> Jerome
> 
> 

