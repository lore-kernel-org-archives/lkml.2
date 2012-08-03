Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2HCLNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 07:13:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2HCLN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 07:13:26 -0400
Date: Fri, 3 Aug 2012 13:12:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 03/17] perf, x86: Add copy_from_user_nmi_nochk for best
 effort copy
Message-ID: <20120803111255.GB937@krava.brq.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-4-git-send-email-jolsa@redhat.com>
 <501ACB42.6060201@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501ACB42.6060201@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 11:47:30AM -0700, Andy Lutomirski wrote:
> On 07/22/2012 05:14 AM, Jiri Olsa wrote:
> > Adding copy_from_user_nmi_nochk that provides the best effort
> > copy regardless the requesting size crossing the task boundary.
> > 
> > This is going to be useful for stack dump we need in post
> > DWARF CFI based unwind, where we have predefined size of
> > the user stack to dump, and we need to store the most of
> > the requested dump size, regardless this size is crossing
> > the task boundary.
> 
> Huh?  This is a TASK_SIZE check, which makes sure that the request
> doesn't cross into kernel land.  Otherwise userspace could presumably
> read kernel memory by setting bogus values of sp.

haven't realized that..  new version won't have this

thanks,
jirka
