Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab1AMBqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:46:09 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42512 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604Ab1AMBqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:46:07 -0500
X-Sasl-enc: bAiR6o5ghbugcm2iWM6cmX1KdwgmQUpTTAlvVi2MczOi 1294883165
Subject: Re: [announce] vfs-scale git tree update
From: Ian Kent <raven@themaw.net>
To: Nick Piggin <npiggin@gmail.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, aelder@sgi.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikNa8dqkwA617QG6hkMRrVLXNWO+1jBRhoaQdio@mail.gmail.com>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink> <1294804776.2821.4.camel@perseus>
	 <87aaj6u3oi.fsf@linux.vnet.ibm.com> <1294808464.2821.15.camel@perseus>
	 <AANLkTikNa8dqkwA617QG6hkMRrVLXNWO+1jBRhoaQdio@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 09:46:00 +0800
Message-ID: <1294883160.2757.2.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 11:58 +1100, Nick Piggin wrote:
> On Wed, Jan 12, 2011 at 4:01 PM, Ian Kent <raven@themaw.net> wrote:
> > On Wed, 2011-01-12 at 10:19 +0530, Aneesh Kumar K. V wrote:
> >> for 9p I did the other way round. lookup now set the dentry op for both
> >> negative and positive dentries and rest of the place we dropped
> >> d_set_d_op (b8b80cf37c7f0e32729262f805bc0fa81c3e9d12 have the details)
> >
> > Sadly I can't do that.
> >
> > For now I need to avoid calls to ->d_revalidate() as much as possible to
> > reduce a potential deadlock and have access to the flags of the negative
> > dentry (during create) for the purpose of blocking concurrent walks.
> 
> What prevents your d_revalidate from just checking for negative dentry?

Whether the dentry is negative or not doesn't change the need to block
walks which introduces the possibility of blocking while holding the
parent i_mutex, since it can't be released in revalidate.


