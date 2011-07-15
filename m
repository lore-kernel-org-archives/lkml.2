Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1GOPHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1GOPHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:07:43 -0400
Date: Fri, 15 Jul 2011 11:07:34 -0400
From: Jason Baron <jbaron@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] dynamic_debug: Remove uses of KERN_CONT in
 dynamic_emit_prefix
Message-ID: <20110715150734.GA2493@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
 <07ef9de13b16d5c50bc36f8c8d9a9aa28a05f2ca.1310657068.git.jbaron@redhat.com>
 <CAO+b5-qQ452VojorX_p4W2orh4DKnM206TA3F5yA2fnhcPhXsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO+b5-qQ452VojorX_p4W2orh4DKnM206TA3F5yA2fnhcPhXsQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 12:04:22PM +0200, Bart Van Assche wrote:
> On Thu, Jul 14, 2011 at 6:09 PM, Jason Baron <jbaron@redhat.com> wrote:
> > +       char tid[sizeof(int) + sizeof(int)/2 + 4];
> > +       char lineno[sizeof(int) + sizeof(int)/2];
> 
> It's not clear to me where the array bounds come from ? Also, why
> sizeof(int) + sizeof(int)/2 instead of sizeof(int)*3 + 1 ?
> 
> Bart.

hmmm...for the tid it bounded by PID_MAX_LIMIT, which is 4 million, so
you need 7 characters + 3 for the brackets and space = 10. So that looks
right to me. Although I'm not sure where the sizeof() comes from? Joe?

For the lineno, it is 24 bits, so it can be 2^24 = 16,777,216, or 8
characters, so I think the 6 is incorrect. Although, in practice I don't
think we have any files that are that big. Joe?

Thanks,

-Jason
