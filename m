Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab1KHWOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:14:03 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:15703
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932137Ab1KHWOB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:14:01 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dK9371K1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUD4F7-01-90Z-02
X-M-MSG: 
From: "Petkov, Borislav" <Borislav.Petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>
CC: Daniel Drake <dsd@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Geode LX boot fails after x86 microcode revision change
Thread-Topic: Geode LX boot fails after x86 microcode revision change
Thread-Index: AQHMnlD57YAO6bPZokyNta5nuC+qkJWjweoAgAAZOAD//64ekw==
Date: Tue, 8 Nov 2011 22:13:56 +0000
Message-ID: <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
 <20111108203116.GF25083@aftab>,<4EB9A6BC.7050600@zytor.com>
In-Reply-To: <4EB9A6BC.7050600@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.13.16]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/08/2011 12:31 PM, Borislav Petkov wrote:
> >
> > it might be that the Geode doesn't have the patch level MSR.., can you
> > send /proc/cpuinfo from a working kernel please, say 3.1?
> >
> > Although, I have rdmsr_safe in the patch there so it actually shouldn't
> > be an issue, theoretically.
> >
> 
> rdmsr_safe() requires exception table support, may not be available yet.
> 
>        -hpa

This could definitely explain why it hangs, the rdmsr_safe call is
 in early_init_amd(), so it could really be too early for exception tables.

If so, then a family check is unavoidable.

Thanks.

(Please forgive the formatting, I'm using the xchange crap)



