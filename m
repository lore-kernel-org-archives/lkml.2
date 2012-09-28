Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab2I1RiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:38:12 -0400
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:45945 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2I1RiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:38:10 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Sep 2012 13:37:56 -0400
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to
 cleanup
Thread-Topic: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to
 cleanup
Thread-Index: Ac2dn/8a2m9VsopsQbSzhLQdmj5q5A==
Message-ID: <1348853876.2229.22.camel@thor>
References: <1347039854.6288.8.camel@thor> <504A3FA9.1050502@zytor.com>
	 <504D6490.2060606@oracle.com>
In-Reply-To: <504D6490.2060606@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8SHcGDk012336

On Sun, 2012-09-09 at 23:54 -0400, zhenzhong.duan wrote:
> 
> äº 2012-09-08 02:40, H. Peter Anvin å†™é“:
> > On 09/07/2012 10:44 AM, Peter Hurley wrote:
> > \>
> >> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c 
> >> b/arch/x86/kernel/cpu/mtrr/cleanup.c
> >
> > I really don't like it as it introduces yet another user of max_pfn, 
> > which should be going away.  Furthermore, the better question is what 
> > remaining needs there are for MTRR cleanup; historically the reason 
> > was that it prevented the display from being mapped WC via MTRR due to 
> > the MTRR conflict resolution rules favoring UC.
> For a large memory system, mtrr_cleanup offten fail in most case. Even 
> if it succeed, it often occupy all of MTRR entrys.
> How was display mapped as WC in above case?

Without this patch, mtrr_cleanup could not optimize. The original MTRR
setup from BIOS remained, which left the display as UC (and a lot of log
spew).

> Why did bios give a lot of space then real mem, for hotplug?

I assume the reason was for hotplug.

An interesting side note: more recent revisions of this BIOS (rev. A11)
report one less variable MTRR (so, IA32_MTRRCAP is writable?)

> > However, the right way to fix that is to use the PAT interfaces, which 
> > doesn't have this drawback -- then MTRR cleanup becomes entirely 
> > superfluous and the problem goes away.
> Do you mean disable MTRR totally here?

Well, since PAT entries marked WC override all MTRR settings, whatever
the BIOS set the variable MTRRs to becomes irrelevant, so not disabled
but rather ignored.

Regards,
Peter Hurley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
