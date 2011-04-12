Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1DLK20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:28:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab1DLK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=mwC5UzhqHlQscMZf+eSfSXVBEEYphbgLqE03LttYH3FBO8DsBbpTwElCcvdzD+3ZWj
         PJ5Qo5wNvbIPXFdQY/S7PjK6Oag4KmKrDdAgiAvQLA0qRl2veKaFp6wMdzKQPy2d6ulA
         QoQTNr2erVoYSVNKw+43Ym441+Y5bOfFJeFA8=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Timur Tabi" <timur@freescale.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Mel Gorman" <mel@csn.ul.ie>, "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
References: <20110411220345.9B95067C@kernel> <20110411220346.2FED5787@kernel>
 <20110411152223.3fb91a62.akpm@linux-foundation.org>
Date: Tue, 12 Apr 2011 12:28:19 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vttl1ho83l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110411152223.3fb91a62.akpm@linux-foundation.org>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>> +void __free_pages_exact(struct page *page, size_t nr_pages)
>> +{
>> +	struct page *end = page + nr_pages;
>> +
>> +	while (page < end) {
>> +		__free_page(page);
>> +		page++;
>> +	}
>> +}
>> +EXPORT_SYMBOL(__free_pages_exact);

On Tue, 12 Apr 2011 00:22:23 +0200, Andrew Morton wrote:
> Really, this function duplicates release_pages().

It requires an array of pointers to pages which is not great though if one
just wants to free a contiguous sequence of pages.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
