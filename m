Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0CWX4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:56:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0CWX4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:56:08 -0400
X-Authority-Analysis: v=1.0 c=1 a=iGnHfCumZfoA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=IsN2uUwMIloV0a3CCIgA:9 a=fI_a8BJSEWiCs0VJdsMA:7 a=hqa4x0i7Bgwbl1yusknQb2Z-0m8A:4 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [Cluster-devel] [PATCH 10/18] gfs2: Provide config option for
 enabling trace points
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       cluster-devel@redhat.com
In-Reply-To: <1269345667.2438.12.camel@localhost>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-11-git-send-email-jack@suse.cz>
	 <1269345667.2438.12.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 19:56:05 -0400
Message-ID: <1269388565.5363.380.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 12:01 +0000, Steven Whitehouse wrote:
> Hi,
> 
> Now in the GFS2 -nmw git tree. Thanks,
> 

Note, this depends on patch 1 which we have not yet determined if it
should be applied or not.

-- Steve

> Steve.
> 
> On Tue, 2010-03-23 at 01:32 +0100, Jan Kara wrote:
> > CC: cluster-devel@redhat.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/gfs2/Kconfig      |    8 ++++++++
> >  fs/gfs2/trace_gfs2.h |    2 ++
> >  2 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> > index 4dcddf8..872ced2 100644
> > --- a/fs/gfs2/Kconfig
> > +++ b/fs/gfs2/Kconfig
> > @@ -38,3 +38,11 @@ config GFS2_FS_LOCKING_DLM
> >  	  Most users of GFS2 will require this. It provides the locking
> >  	  interface between GFS2 and the DLM, which is required to use GFS2
> >  	  in a cluster environment.
> > +
> > +config GFS2_TRACER
> > +	bool "GFS2 tracing"
> > +	depends on GFS2_FS && EVENT_TRACING
> > +	help
> > +	  Provide trace points in block allocation functions, locking, and
> > +	  journaling code.
> > +
> > diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
> > index 148d55c..5f4faf3 100644
> > --- a/fs/gfs2/trace_gfs2.h
> > +++ b/fs/gfs2/trace_gfs2.h
> > @@ -1,5 +1,7 @@
> >  #undef TRACE_SYSTEM
> > +#undef TRACE_CONFIG
> >  #define TRACE_SYSTEM gfs2
> > +#define TRACE_CONFIG CONFIG_GFS2_TRACER
> >  
> >  #if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
> >  #define _TRACE_GFS2_H
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


