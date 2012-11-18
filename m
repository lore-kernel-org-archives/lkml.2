Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2KROix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:38:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59601 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752541Ab2KROiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:38:51 -0500
Message-ID: <1353249531.15959.10.camel@joe-AO722>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <vkondrat@qti.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 18 Nov 2012 06:38:51 -0800
In-Reply-To: <3304277.iqgq3GH3Yo@lx-vladimir>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352912932.9388.23.camel@joe-AO722> <29414886.frl7IkqOMP@lx-vladimir>
	 <3304277.iqgq3GH3Yo@lx-vladimir>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-18 at 11:47 +0200, Vladimir Kondratiev wrote:
> I see 2 drivers that use dynamic prefix:
> 
> - mentioned above drivers/tty/ipwireless/hardware.c
> - drivers/isdn/hardware/mISDN/
> 
> I see several options:
> 
> 1) require prefix_str to be constant. Patch code mentioned. For example,
> code above may reads:
> 
> static void dump_data_bytes(const char *type, const unsigned char *data,
> 			    unsigned length)
> {
> 	pr_debug(IPWIRELESS_PCCARD_NAME ": %s %s\n",
> 			type, data_type(data, length));
> 	print_hex_dump_bytes(IPWIRELESS_PCCARD_NAME, 0, (void *)data,
> 			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
> }
> 
> 2) introduce fixed format string in DEFINE_DYNAMIC_DEBUG_METADATA, like
> 
> DEFINE_DYNAMIC_DEBUG_METADATA((descriptor, "hexdump");
> 
> 3) remove print_hex_dump_bytes from this patch
> 
> I think 1) is the best, opinions?

Another option could be testing __builtin_constant_p(prefix)


