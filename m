Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2LGTck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:32:40 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64703 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2LGTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121207192138.GA22308@sergelap>
References: <3c3146b8bea5d8590ebc40ca1d22a562a5172873.1354904275.git.luto@amacapital.net>
 <20121207192138.GA22308@sergelap>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Dec 2012 11:32:18 -0800
Message-ID: <CALCETrUZyD=Z6bQ3vZC8_9giv67-BuZGm2PgshM0E5hUDe6=bQ@mail.gmail.com>
Subject: Re: [PATCH] Document how capability bits work
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        mtk.manpages@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 11:21 AM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  Documentation/security/capabilities.txt | 161 ++++++++++++++++++++++++++++++++
>>  1 file changed, 161 insertions(+)
>>  create mode 100644 Documentation/security/capabilities.txt
>
> TBH, I think a pointer to the capabilities.7 man page would be better.
> (plus, if you feel they are needed, updates to the man page)

Updating capabilities.7 wouldn't be a bad idea, but IMO it certainly
needs work.  For example, it says:

       Inheritable:
              This is a set of capabilities preserved across an execve(2).  It
              provides a mechanism for a process to assign capabilities to the
              permitted set of the new program during an execve(2).

This is, at best, misleading.

Permitted says:

              If  a  thread  drops a capability from its permitted set, it can
              never reacquire that capability (unless it execve(2)s  either  a
              set-user-ID-root  program,  or  a  program whose associated file
              capabilities grant that capability).

That's just not true (e.g. if uid == 0).

The text later on is better, but I think it would be helpful to have a
detailed and succinct description of what's going on.

I would be happy to revise this patch to reference capabilities.7.

--Andy
