Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab1CXSWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:22:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35447 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab1CXSWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RPj3cUSSuQb13BYGCUAlMlFXELAMCeLR+MP/GBGwttJeRSaXuzBg9VbqXz5uR2zqfX
         oRocRmJQFL8vj88FmxPyyrIqrlx693FQAQk92h81eKqAhz7vfuef0j1p+WmzoS2n/+2o
         Yqnvj+W1Pdma2A/mYlAZNHyzXkNv1UkTI01ZI=
Date: Thu, 24 Mar 2011 20:22:30 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Reichelt <debian@nachtgeist.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for
 /proc/<pid> dirs
Message-ID: <20110324182230.GB5187@p183.telecom.by>
References: <4D8AC408.9000503@nachtgeist.net>
 <20110324073225.GA3806@p183.telecom.by>
 <4D8B03D6.2090204@nachtgeist.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B03D6.2090204@nachtgeist.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:41:58AM +0100, Daniel Reichelt wrote:
> > Keeping u/g/o inside kernel is horrible.
> 
> Why exactly? Since it's only a char and not char[] I don't see the
> disadvantage over int or a define or whatever. Of course I could always
> change that if that's a de-facto standard I just didn't know about.

Keep mode_t inside kernel, this will get rid of many ifdefs.
 
> > What is the usecase? Content of /proc/* is identical.
> 
> Use-case is to isolate process information from other users' or groups'
> eyes, e.g. with 550 the output of ps aux only lists processes of the
> groups your user is a member of.

This is doable with some ps(1) switch, I'm sure.

The content of /proc/$PID directory is not a secret.
