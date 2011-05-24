Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1EXRA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:00:59 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1631 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab1EXRA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:00:58 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DDBE432.3040207@broadcom.com>
Date: Tue, 24 May 2011 19:00:34 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
 <20110522122325.108b1c86@lxorguk.ukuu.org.uk>
 <4DD905CC.8040407@broadcom.com>
 <20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
 <4DDB622B.1050005@broadcom.com>
 <20110524104404.336c765f@lxorguk.ukuu.org.uk>
 <4DDB81FD.2020903@broadcom.com>
 <20110524112732.67d92b2f@lxorguk.ukuu.org.uk>
 <4DDB8AB5.7080808@broadcom.com>
 <20110524135705.00f7fb12@lxorguk.ukuu.org.uk>
In-Reply-To: <20110524135705.00f7fb12@lxorguk.ukuu.org.uk>
X-WSS-ID: 61C53A964NS11466686-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 02:57 PM, Alan Cox wrote:
> On Tue, 24 May 2011 12:38:45 +0200
> "Arend van Spriel"<arend@broadcom.com>  wrote:
>
>> On 05/24/2011 12:27 PM, Alan Cox wrote:
>>>> Not sure whether you mean the source code or the object code. I build
>>>> kernel with debug symbols so the sizes are bit higher.
>>> nm will tell you the actual sizes. I think the n_gsm code is about 500
>>> bytes or so and chunks of it inline.
>> Not counting the crc table I assume.
> I forget but I think including - its a tiny tiny bit of code once inlined.

I used nm on both flavours.

dynamic crc table based on polynomial and bit order
---------------------------------------------------
00000000 00000026 T crc8
00000030 000000dc T crc8_create

fixed crc table with table selection based on bit order
-------------------------------------------------------
00000000 00000026 T crc8
00000030 0000002b T crc8_create
00000100 00000100 r crc8_table_lsb
00000000 00000100 r crc8_table_msb

The first requires the user to provide buffer to hold the table. The 
difference is in the crc_create() function (maybe better named 
crc_populate_table() in first, and crc_select_table() in second). It is 
177 bytes larger. The crc calculating function is 38 bytes. Still pretty 
small I would think.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


