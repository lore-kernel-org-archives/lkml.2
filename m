Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0I1Qf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab0I1Qf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:35:27 -0400
Message-ID: <4CA21906.1080002@redhat.com>
Date: Tue, 28 Sep 2010 18:34:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory
 sections
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA1E338.6070201@redhat.com> <20100928151218.GJ14068@sgi.com>
In-Reply-To: <20100928151218.GJ14068@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/28/2010 05:12 PM, Robin Holt wrote:
> >  Why not update sysfs directory creation to be fast, for example by
> >  using an rbtree instead of a linked list.  This fixes an
> >  implementation problem in the kernel instead of working around it
> >  and creating a new ABI.
>
> Because the old ABI creates 129,000+ entries inside
> /sys/devices/system/memory with their associated links from
> /sys/devices/system/node/node*/ back to those directory entries.
>
> Thankfully things like rpm, hald, and other miscellaneous commands scan
> that information.  On our 8 TB test machine, hald runs continuously
> following boot for nearly an hour mostly scanning useless information
> from /sys/

I see - so the problem wasn't just kernel internal; the ABI itself was 
unsuitable.  Too bad this wasn't considered at the time it was added.

(129k entries / 1 hour = 35 entries/sec; not very impressive)

-- 
error compiling committee.c: too many arguments to function

