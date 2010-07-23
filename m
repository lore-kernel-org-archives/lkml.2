Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab0GWMk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:40:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62820 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0GWMkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kut1lHqKDA7SrZSlYBm6YSsuRGGan3U7oDWAt0KsYH6Uhxe1N1gsZYm4N6W4hAWwF5
         6/q94AZ6lQOXEEjMRN1zT+T5oLQ6s246goGVLQ5WTbar6iDN0D65hy76cCI49idYPDK7
         Ua7KGAClPZpkfwXaO7pZhj5ss+5YAi2E1WOyw=
Message-ID: <4C498DD2.1040002@gmail.com>
Date: Fri, 23 Jul 2010 13:40:50 +0100
From: Iain <selsinork@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: make acpi_idle Nehalem-aware
References: <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain> <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com> <20100525124325.GC7876@srcf.ucam.org> <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain> <20100525185507.GA15997@srcf.ucam.org> <alpine.LFD.2.00.1007211729550.409@localhost.localdomain> <20100722074750.GA22520@one.firstfloor.org> <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain> <4C48B730.30708@gmail.com> <alpine.LFD.2.00.1007221751550.13016@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007221751550.13016@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> You read it correctly, your BIOS does not request BM_STS, mjg59's does.

Right, and on a DL360 G6 with the 07-24-2009 bios version I saw the same.

> I expect that is to enable PCC, which would change P-states,
> but unlikely would have an effect on C-states.

I found another option in the bios to limit or disable the C-states today, so plenty of opportunity to configure the system into an 
odd state.

> If you can try it both ways that might be good to know.
> (include powertop display once again)
> Of course, the default setting is what 99% of customers use...

I'll upload an archive to the bugzilla entry with the details. What seems to happen is that when you set the default Balanced Power 
and Performance mode the CST code vanishes completely and the processor manages to get to c6 some of the time. Enable OS Control 
mode and the bad CST code appears.

> This is BIOS writer "value add".
> Unclear how it migh be an improvement over what Linux has been shipping 
> for years.

Well yes, having Linux and the bios fighting for control probably isn't going to help.

> Please upload the output from dmidecode to the bug report.
> I am hopeful that you have a current BIOS and that
> Matthew may have an pre-production BIOS.

I've uploaded an archive with dmidecode, turbostat and powertop dumps. There are dumps with the bios set to the default, and to OS 
Control mode.
The original bios on my DL360G6 was 07-24-2009 and has the same issue as Matthew. I upgraded the machine to the latest 2010.05.15 
and repeated the tests.
Good news is that the new bios has fixed the CST code so that the Access length values are all 0x01 when they're present and the 
dumps show the processor getting into c6 much more.

So you were correct, bios fix was needed.

Iain
