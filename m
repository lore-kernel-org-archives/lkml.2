Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab1JTRwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1JTRwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:52:11 -0400
Date: Thu, 20 Oct 2011 13:50:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111020175022.GD13685@redhat.com>
References: <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
 <20111019165932.GH1140@redhat.com>
 <20111019220553.GQ25124@google.com>
 <20111019220717.GR25124@google.com>
 <20111019235146.GS25124@google.com>
 <20111020134137.GA13685@redhat.com>
 <20111020161123.GW25124@google.com>
 <CAPXgP12hvveG8y31Q77BQAzrdaeaux=Eoonu8RinGmP3DfTsbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP12hvveG8y31Q77BQAzrdaeaux=Eoonu8RinGmP3DfTsbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 06:16:04PM +0200, Kay Sievers wrote:
> On Thu, Oct 20, 2011 at 18:11, Tejun Heo <tj@kernel.org> wrote:
> > I think this is essentially a bug.  If you have something like "dev =
> > find_and_get(); put(dev); return dev != NULL;", it's a pretty good
> > indication something is pretty screwed there, so unless someone
> > screams really loud, I think I'm gonna push for removal of the
> > feature.
> 
> Matching on unpredictable dev_t inside the kernel or in userspace is a
> serious bug. We can't do anything like that ever on a modern system,
> these times are long over.
> 
> Yes, please get rid of this misguided logic, nobody should get the
> impression that this can ever work.

Kay,

So are you suggesting don't use device major/minor number for specifying
the rules in cgroup or you are suggesting the same thing as Tejun that
automatically get rid of rule when device goes away. 

If it is former, then what else one can use for specifying the rule.

Thanks
Vivek
