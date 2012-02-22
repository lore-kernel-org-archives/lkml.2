Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2BVO0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:26:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15105 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2BVO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:26:36 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=2KZ9ky_Lc6WSCjwFVl8A:9 a=PUjeQqilurYA:10 a=HkzKWh34C-UgMI6o:21 a=Vrdr8n1nM18vUgEJ:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329920794.25686.95.camel@gandalf.stny.rr.com>
Subject: Re: RAS trace event proto
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 22 Feb 2012 09:26:34 -0500
In-Reply-To: <4F44EE60.8030400@redhat.com>
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com>
	 <20120221141231.GA15515@aftab>
	 <1329835698.25686.60.camel@gandalf.stny.rr.com>
	 <20120221145943.GB15515@aftab>
	 <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com>
	 <20120222104324.GA26845@aftab> <4F44D948.3000205@redhat.com>
	 <20120222122555.GD26845@aftab> <4F44EE60.8030400@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 11:32 -0200, Mauro Carvalho Chehab wrote:

> @Steven:
> 
> In a matter of fact, the error_severity and error_type should be enum's. We should not
> use enum's on ioctl's, as enum size is not portable. Can it be used inside perf, or should
> them be exported, on perf, via integer (like the above proposal)?

I don't know exactly how perf does it today, but I'm sure it's similar
to trace-cmd.

You can use an enum, as it just comes through as a number. Each field is
given the size of that field. If it's an int it stays an int.

Note though, perf and trace-cmd do not know how to convert the number
back to a enum name. You can use the __print_symbols() feature, but
that's about it.

-- Steve


