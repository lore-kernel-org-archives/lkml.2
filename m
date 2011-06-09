Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1IFS6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:58:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45118 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753076Ab1IFS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:58:48 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18WXPYASKwWOCzpR2fhGaUeCFK421UzaR9/d17zkd
	57lfllcz60EFec
Message-ID: <4DF117B8.8080408@gmx.net>
Date: Thu, 09 Jun 2011 20:58:00 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 'flags' in rsparser.c change from 'register disabled resources'
 patch
References: <20110822005902.GA30602@gallifrey>
In-Reply-To: <20110822005902.GA30602@gallifrey>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

your observation is correct.  In fact, the patch can be simplified by 
not setting the IORESOURCE_DISABLED flag at all, which is functionally 
equivalent to the current state where the compiler removes this value 
because it cannot be assigned to a char.  A quick compare of the 
generated code of the current version (with  IORESOURCE_DISABLED 
included) and with IORESOURCE_DISABLED not used at all yields pretty 
much the same code.

I realized the problem only days after I submitted my patch. 
Apparently, a follow-up patch which takes care of the 
IORESOURCE_DISABLED flags did not make it into the mainline kernel. 
I'll resend it as a response to this post shortly.  In addition, in 
https://lkml.org/lkml/2011/7/31/50 I submitted a much simpler version of 
the patch which better exposes the change it introduces but requires 
29df8d8f8702f0f53c1375015f09f04bc8d023c1 to be reverted.

--- Witold
