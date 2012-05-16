Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab2EPRFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:05:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2EPRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:05:15 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=g_LhDMiRcOYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=_Edq1vAum5xT96NchGUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337187913.6724.53.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Wed, 16 May 2012 13:05:13 -0400
In-Reply-To: <4FB3C690.4000006@redhat.com>
References: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
	  <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com>
	  <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com>
	  <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com>
	  <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com>
	  <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com>
	 <1337172492.6724.36.camel@gandalf.stny.rr.com>
	 <4FB3C690.4000006@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 12:24 -0300, Mauro Carvalho Chehab wrote:

> > Here's another trick if you want to get rid of the space and keep both
> > fields:
> > 
> > TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s%s%s)",
> >            (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
> >                  ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
> >                  "Fatal" : "Uncorrected"),
> > 
> >            __get_str(msg),
> >            __get_str(label),
> >            __entry->mc_index,
> >            __get_str(location),
> >            __get_str(detail),
> > 	   strlen(__get_str(detail)) &&
> > 	    strlen(__get_str(driver_detail) ? " ": "",
> >            __get_str(driver_detail))
> 
> Great! I'll use that trick, thanks!

strlen() may be too overblown. The following should work and is more
efficient:

	(((char *)__get_str(detail))[0] &&
	 ((char *)__get_str(driver_detail))[0]) ? " " : "",

-- Steve


