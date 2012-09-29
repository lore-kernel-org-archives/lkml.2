Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab2I2DQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 23:16:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46642 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788Ab2I2DQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 23:16:49 -0400
Message-ID: <5066680E.3090907@zytor.com>
Date: Fri, 28 Sep 2012 20:16:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
References: <1347039854.6288.8.camel@thor> <504A3FA9.1050502@zytor.com>  <504D6490.2060606@oracle.com> <1348853876.2229.22.camel@thor>
In-Reply-To: <1348853876.2229.22.camel@thor>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 10:37 AM, Peter Hurley wrote:
> 
> An interesting side note: more recent revisions of this BIOS (rev. A11)
> report one less variable MTRR (so, IA32_MTRRCAP is writable?)
> 
>>> However, the right way to fix that is to use the PAT interfaces, which 
>>> doesn't have this drawback -- then MTRR cleanup becomes entirely 
>>> superfluous and the problem goes away.
>> Do you mean disable MTRR totally here?
> 
> Well, since PAT entries marked WC override all MTRR settings, whatever
> the BIOS set the variable MTRRs to becomes irrelevant, so not disabled
> but rather ignored.
> 

The whole point is that the display stuff should not use MTRR, but
rather use PAT to provide WC.  Then we don't need to "clean up" the
BIOS-set MTRRs.

	-hpa

