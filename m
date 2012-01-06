Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab2AFXJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:09:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2AFXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:09:39 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5Kkf9dAxP3YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=wcSRNVWAP18JcTYqjYUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325891377.7642.17.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] recordmcount: Fix handling of elf64 big-endian objects.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Date: Fri, 06 Jan 2012 18:09:37 -0500
In-Reply-To: <4F075CAE.2040709@gmail.com>
References: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com>
	 <1324350542.5916.48.camel@gandalf.stny.rr.com> <4F075CAE.2040709@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 12:42 -0800, David Daney wrote:

> Any more feedback on this patch?  Should I look for it to appear in 3.3?

OK, I tested it and then I noticed that mainline doesn't have
"HAVE_C_RECORDMCOUNT" set. Is that going in the PPC tree? I added that
to arch/powerpc/Kconfig, and did see the bug you saw. After adding your
patch, I did a diff of the available_filter_functions and had this:

> .elf_core_extra_phdrs
> .elf_core_write_extra_phdrs
> .elf_core_write_extra_data
> .elf_core_extra_data_size

These 4 functions were added after doing the change. Weird.

Anyway, I'll run the change through my normal tests and then push it
out.

Thanks!

-- Steve


