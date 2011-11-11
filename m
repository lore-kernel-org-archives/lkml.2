Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab1KKNMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:12:38 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:54075
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab1KKNMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:12:36 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Kumar Gala <galak@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/17] powerpc: Split up PHYS_64BIT config option to
 fix "select" issues
Thread-Topic: [RFC PATCH 02/17] powerpc: Split up PHYS_64BIT config option
 to fix "select" issues
Thread-Index: AQHMnzzdhs3Oy1OOpUirq+wMQb9GQpWmJMiAgACN2oD//6CVAIABLeEAgACMJQA=
Date: Fri, 11 Nov 2011 13:12:31 +0000
Message-ID: <4EBD1F3E.2040402@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
  <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com>
  <4EBBD9DF.6080100@freescale.com>
  <501ACA94-491F-43A7-9DCF-485BEE824DD5@boeing.com>
  <4EBC00D2.2030208@freescale.com> <1320987054.21206.55.camel@pasglop>
In-Reply-To: <1320987054.21206.55.camel@pasglop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1)
 Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <A419414BBD5C94438D000514307BDFB3@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:

> For PHYS_64BIT, I'm not 100% certain at this point what the best
> approach it. It should clearly be fixed and hidden for real 64-bit. As
> for the rest, should it be user selectable ?

I have been unable to convince our BSP teams that the minor performance 
improvement of a 32-bit kernel vs 36-bit is not worth the hassle.  We ship 
a lot of lower-end e500 systems that will never have more than 2GB of memory.

The P1022DS is an example.  We ship 32-bit and 36-bit versions of U-Boot, 
the kernel, and the device tree.  I recently added code to U-boot to 
detect if you have a mismatched U-Boot and device tree, because it is so 
easy to mess that up.  I would like nothing more than to abandon 32-bit 
for all e500, but I don't see Freescale allowing that any time soon.

-- 
Timur Tabi
Linux kernel developer at Freescale
