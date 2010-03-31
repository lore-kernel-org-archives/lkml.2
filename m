Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab0CaXig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:38:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53994 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0CaXie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:38:34 -0400
Message-ID: <4BB3DC23.50005@zytor.com>
Date: Wed, 31 Mar 2010 16:34:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org>
In-Reply-To: <4BB3D0F4.902@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 03:47 PM, Yinghai Lu wrote:
>>
>> Well and that whole #ifdeffery is disgusting as well - even if the goal was to 
>> remove CONFIG_NO_BOOTMEM ASAP.
>>
>> Please learn to use proper intermediate helper functions and at minimum put 
>> the conversion ugliness somewhere that doesnt intrude our daily flow in .c 
>> files. The best rule is to _never ever_ put an #ifdef construct into a .c 
>> file. It doesnt matter what the goal if the #ifdef is - such ugliness in code 
>> is never justified.
> 
> if you agree that i can have one nobootmem.c in mm/
> 

That would be better, or more commonly, use inlines.

I'm still totally puzzled about this patch as well as the comment:

+#if defined(CONFIG_NO_BOOTMEM) && defined(MAX_NUMNODES)
+	/* In case some 32bit systems don't have RAM installed on node0 */
+        totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
+#else
 	totalram_pages += free_all_bootmem();
+#endif


Why is that "32 bits" specific?  Second, MAX_NUMNODES is defined
whenever <linux/numa.h> is included, so what on Earth is this supposed
to signify?  Are you trying to say MAX_NUMNODES > 1?  Or are you trying
to say CONFIG_NUMA?

Furthermore, I really don't see the connection between this and James
Morris' reported problem, which he reports as "amd64", which presumably
is an x86-64 kernel and not 32 bits...  James, is that correct?  Any
more details you can give about the system?  I *really* don't want to go
into cargo cult programming mode, that would suck eggs no matter what.

	-hpa



