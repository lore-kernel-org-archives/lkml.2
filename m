Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0KLSgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:36:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KLSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xj2eMg2/nZJrPhYygqjb0sXnVMQW+M4yKXsgIHtk1IDMf/a13C3rhqhdv32pqZGrZU
         2FgOnWAIAld3BnF6vABg==
Date: Fri, 12 Nov 2010 10:36:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Artur Baruchi <mail.baruchi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: mem_map array on NUMA
In-Reply-To: <AANLkTiniDRw5rwCgAFRyX0ekZJHxbs0bZqs4NXGo1VKW@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011121033340.5830@chino.kir.corp.google.com>
References: <AANLkTinPX0by5GMTUbbEkb_WeayfY0hBzjYxrZM7asaY@mail.gmail.com> <alpine.DEB.2.00.1011111259340.25829@chino.kir.corp.google.com> <AANLkTiniDRw5rwCgAFRyX0ekZJHxbs0bZqs4NXGo1VKW@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Artur Baruchi wrote:

> Hi David.
> 
> Thanks for your answer.
> 
> Basically, I would like to get information about memory pages, without
> "worry" about which zone its owned. I tried to use the code you've send, but
> some macros are not beeing exported by the Kernel (I cannot use it in
> drivers/modules). Im facing the follow errors:
> 
> *WARNING: "next_zone" [/root/DRIVER/xxxxxxxx.ko] undefined!
> WARNING: "first_online_pgdat" [/root/DRIVER/**xxxxxxxx.ko**] undefined!*
> 
> Do you have any idea about how can I handle this error?
> 

For your use-case, you can simply iterate through each pfn without 
worrying about their zones, something like:

	unsigned long pfn;

	for (pfn = 0; pfn < max_pfn; pfn++) {
		struct page *page;

		if (!pfn_valid(pfn))
			continue;
		page = pfn_to_page(pfn);
		/* do something with page */
	}		

> Thanks in advance.
> 
> Att.
> Artur Baruchi
