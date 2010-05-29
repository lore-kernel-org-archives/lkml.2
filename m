Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0E2SmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 14:42:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51394 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0E2SmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 14:42:18 -0400
Message-ID: <4C015FE6.8040004@oracle.com>
Date: Sat, 29 May 2010 11:41:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Documentation/timers/hpet_example.c compile bug
References: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C016004.0177:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/10 04:35, Heiko Carstens wrote:
> Hi Randy,
> 
> since your commit e61863099f58e458f08c101da87da752a1e009f5
> "Documentation/timers/: split txt and source files" I get this compile
> error on s390 with an allyesconfig:
> 
> In file included from Documentation/timers/hpet_example.c:15:
> /usr/include/linux/hpet.h:11: error: expected specifier-qualifier-list before 'u64'

Where is the u64?  My (x86_64) copy of /usr/include/linux/hpet.h looks like:

     1	#ifndef	__HPET__
     2	#define	__HPET__ 1
     3	
     4	
     5	
     6	
     7	struct hpet_info {
     8		unsigned long hi_ireqfreq;	/* Hz */
     9		unsigned long hi_flags;	/* information */
    10		unsigned short hi_hpet;
    11		unsigned short hi_timer;
    12	};
    13	
    14	#define HPET_INFO_PERIODIC	0x0010	/* periodic-capable comparator */
    15	
    16	#define	HPET_IE_ON	_IO('h', 0x01)	/* interrupt on */
    17	#define	HPET_IE_OFF	_IO('h', 0x02)	/* interrupt off */
    18	#define	HPET_INFO	_IOR('h', 0x03, struct hpet_info)
    19	#define	HPET_EPI	_IO('h', 0x04)	/* enable periodic */
    20	#define	HPET_DPI	_IO('h', 0x05)	/* disable periodic */
    21	#define	HPET_IRQFREQ	_IOW('h', 0x6, unsigned long)	/* IRQFREQ usec */
    22	
    23	#endif				/* !__HPET__ */

I guess s390 hpet.h looks different?  Does it just need to #include <linux/types.h> ?
Or is the problem the kernel-space u64 vs. userspace __u64?

> Please fix.

Any suggestions?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
