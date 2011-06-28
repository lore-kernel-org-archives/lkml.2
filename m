Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1F1HvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:51:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62751 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1F1Hud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PMxN6tnKLPFahN+iS5rttzR4yHvVVBPbfs7ooHJRSKag6ERleh5kumh40nmWl9RyN2
         WGtuURzcbQJHPPGiskyMQqAg+W47fDDB79CO4CGnevuYCve13KVuXU5qThN9fjQ89idl
         oJQYpz2TD1BDtLgGnzAlGiTjl0J68veZqufu0=
Date: Tue, 28 Jun 2011 11:50:27 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
Message-ID: <20110628075027.GA4051@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <BANLkTine1Q7thbLVUb34ZsRZt4q184dZzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTine1Q7thbLVUb34ZsRZt4q184dZzg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 06:43 +0530, Balbir Singh wrote:
> On Fri, Jun 24, 2011 at 5:38 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > /proc/PID/io may be used for gathering private information.  E.g. for
> > openssh and vsftpd daemons wchars/rchars may be used to learn the
> > precise password length.  Restrict it to processes being able to ptrace
> > the target process.
> >
> 
> Hmm.. How do I reproduce this,

Just register taskstats listener and wait for "vsftpd" process.
read_characters = strlen("USER username\r\n") + strlen("PASSWD
pass\r\n") + 1.

> won't they be enough randomness around
> rchar/wchar by the time the attacker reads it?

No, if you set "UsePrivilegeSeparation yes" in /etc/sshd/sshd_config or
similar setting in vsftpd config (set by default), one process will
have very small io activity, which is 100% related to the io in
question.

http://www.openwall.com/lists/oss-security/2011/06/24/6

So, the total io = io with the network + io with privileged parent.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
