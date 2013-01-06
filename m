Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3AFJWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:22:49 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:24673
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab3AFJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:22:46 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dh17326ahz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758hbe9i1155h)
From: Liu Hui-R64343 <r64343@freescale.com>
To: Simon Jeons <simon.jeons@gmail.com>
CC: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] mm: compaction: fix echo 1 > compact_memory return
 error issue
Thread-Topic: [PATCH] mm: compaction: fix echo 1 > compact_memory return
 error issue
Thread-Index: AQHN6+PQVZX6o0pR+0esPX7n7xyjzZg78a0QgAALGACAAACXwIAACMUAgAAAksA=
Date: Sun, 6 Jan 2013 09:22:41 +0000
Message-ID: <AD13664F485EE54694E29A7F9D5BE1AF4E5EEA@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1357458273-28558-1-git-send-email-r64343@freescale.com>
	 <20130106075940.GA22985@hacker.(null)>
	 <AD13664F485EE54694E29A7F9D5BE1AF4E5BCD@039-SN2MPN1-021.039d.mgd.msft.net>
	 <20130106084610.GA26483@hacker.(null)>
	 <AD13664F485EE54694E29A7F9D5BE1AF4E5E1F@039-SN2MPN1-021.039d.mgd.msft.net>
 <1357463980.1454.0.camel@kernel.cn.ibm.com>
In-Reply-To: <1357463980.1454.0.camel@kernel.cn.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.64]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r069Mtw3021996

>-----Original Message-----
>From: Simon Jeons [mailto:simon.jeons@gmail.com]
>Sent: Sunday, January 06, 2013 5:20 PM
>To: Liu Hui-R64343
>Cc: Wanpeng Li; linux-kernel@vger.kernel.org; mgorman@suse.de;
>akpm@linux-foundation.org; riel@redhat.com; minchan@kernel.org;
>kamezawa.hiroyu@jp.fujitsu.com; linux-mm@kvack.org
>Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory return
>error issue
>
>On Sun, 2013-01-06 at 08:48 +0000, Liu Hui-R64343 wrote:
>> >-----Original Message-----
>> >From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
>> >Sent: Sunday, January 06, 2013 4:46 PM
>> >To: Liu Hui-R64343
>> >Cc: linux-kernel@vger.kernel.org; mgorman@suse.de; akpm@linux-
>> >foundation.org; riel@redhat.com; minchan@kernel.org;
>> >kamezawa.hiroyu@jp.fujitsu.com; linux-mm@kvack.org
>> >Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory
>> >return error issue
>> >
>> >On Sun, Jan 06, 2013 at 08:11:58AM +0000, Liu Hui-R64343 wrote:
>> >>>-----Original Message-----
>> >>>From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
>> >>>Sent: Sunday, January 06, 2013 4:00 PM
>> >>>To: Liu Hui-R64343
>> >>>Cc: linux-kernel@vger.kernel.org; mgorman@suse.de; akpm@linux-
>> >>>foundation.org; riel@redhat.com; minchan@kernel.org;
>> >>>kamezawa.hiroyu@jp.fujitsu.com; linux-mm@kvack.org
>> >>>Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory
>> >>>return error issue
>> >>>
>> >>>On Sun, Jan 06, 2013 at 03:44:33PM +0800, Jason Liu wrote:
>> >>>
>> >>>Hi Jason,
>> >>>
>> >>>>when run the folloing command under shell, it will return error
>> >>>>sh/$ echo 1 > /proc/sys/vm/compact_memory sh/$ sh: write error:
>> >>>>Bad address
>> >>>>
>> >>>
>> >>>How can you modify the value through none privileged user since the
>> >>>mode == 0200?
>> >>
>> >>I write it through privileged user(root). I'm using the GNOME_Mobile
>rootfs.
>> >>
>> >>>
>> >>>>After strace, I found the following log:
>> >>>>...
>> >>>>write(1, "1\n", 2)               = 3
>> >>>>write(1, "", 4294967295)         = -1 EFAULT (Bad address)
>> >>>>write(2, "echo: write error: Bad address\n", 31echo: write error:
>> >>>>Bad address
>> >>>>) = 31
>> >>>>
>> >>>>This tells system return 3(COMPACT_COMPLETE) after write data to
>> >>>compact_memory.
>> >>>>
>> >>>>The fix is to make the system just return 0 instead
>> >>>>3(COMPACT_COMPLETE) from sysctl_compaction_handler after
>> >compaction_nodes finished.
>> >>>
>> >>>What's the special scenario you are in? I couldn't figure out the
>> >>>similar error against latest 3.8-rc2, how could you reproduce it?
>> >>
>> >>I'm using the BusyBox v1.20.2 () built-in shell (ash), it reproduces the
>issue:
>> >100%.
>> >>
>> >>root@freescale /$ sh
>> >>
>> >>
>> >>BusyBox v1.20.2 () built-in shell (ash) Enter 'help' for a list of
>> >>built-in commands.
>> >>
>> >>Could you run strace and see the log:  strace echo 1 >
>> >>/proc/sys/vm/compact_memory
>> >>
>> >
>> >I test it on my desktop against latest 3.8-rc2, can't repoduce it. :)
>> >
>> >write(1, "1\n", 2)                      = 3
>>
>> Here it tells it.
>
>Why this value trouble you?

root@freescale /$strace echo 1 > /proc/sys/vm/compact_memory

write(1, "1\n", 2)                              = 3
write(1, "", 4294967295)                = -1 EFAULT (Bad address)
write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
) = 31

root@freescale /$ sh


BusyBox v1.20.2 () built-in shell (ash)
Enter 'help' for a list of built-in commands.

root@freescale /$  echo 1 > /proc/sys/vm/compact_memory
sh: write error: Bad address

>
>>
>> >close(1)                                = 0
>> >munmap(0xb779c000, 4096)                = 0
>> >close(2)                                = 0
>> >exit_group(0)                           = ?
>> >+++ exited with 0 +++
>> >
>> >Regards,
>> >Wanpeng Li
>> >
>> >>>
>> >>>Regards,
>> >>>Wanpeng Li
>> >>>
>> >>>>
>> >>>>Suggested-by:David Rientjes <rientjes@google.com> Cc:Mel Gorman
>> >>>><mgorman@suse.de> Cc:Andrew Morton <akpm@linux-
>foundation.org>
>> >>>Cc:Rik
>> >>>>van Riel <riel@redhat.com> Cc:Minchan Kim <minchan@kernel.org>
>> >>>>Cc:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >>>>Signed-off-by: Jason Liu <r64343@freescale.com>
>> >>>>---
>> >>>> mm/compaction.c |    6 ++----
>> >>>> 1 files changed, 2 insertions(+), 4 deletions(-)
>> >>>>
>> >>>>diff --git a/mm/compaction.c b/mm/compaction.c index
>> >>>>6b807e4..f8f5c11
>> >>>>100644
>> >>>>--- a/mm/compaction.c
>> >>>>+++ b/mm/compaction.c
>> >>>>@@ -1210,7 +1210,7 @@ static int compact_node(int nid)  }
>> >>>>
>> >>>> /* Compact all nodes in the system */ -static int
>> >>>>compact_nodes(void)
>> >>>>+static void compact_nodes(void)
>> >>>> {
>> >>>> 	int nid;
>> >>>>
>> >>>>@@ -1219,8 +1219,6 @@ static int compact_nodes(void)
>> >>>>
>> >>>> 	for_each_online_node(nid)
>> >>>> 		compact_node(nid);
>> >>>>-
>> >>>>-	return COMPACT_COMPLETE;
>> >>>> }
>> >>>>
>> >>>> /* The written value is actually unused, all memory is compacted
>> >>>>*/ @@
>> >>>>-1231,7 +1229,7 @@ int sysctl_compaction_handler(struct ctl_table
>> >>>>*table,
>> >>>int write,
>> >>>> 			void __user *buffer, size_t *length, loff_t *ppos)
>{
>> >>>> 	if (write)
>> >>>>-		return compact_nodes();
>> >>>>+		compact_nodes();
>> >>>>
>> >>>> 	return 0;
>> >>>> }
>> >>>>--
>> >>>>1.7.5.4
>> >>>>
>> >>>>
>> >>>>--
>> >>>>To unsubscribe, send a message with 'unsubscribe linux-mm' in the
>> >>>>body to majordomo@kvack.org.  For more info on Linux MM,
>> >>>>see: http://www.linux-mm.org/ .
>> >>>>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>> >>>
>> >>
>> >
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in the body
>> to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
