Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0H1Vuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 17:50:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54271 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0H1Vu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 17:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y7LlcR9o3sMTFvl+/SWYmG+RQAP6msPaMx9/9WU8R9Km67Eb/OZ+aEX/tOE865CrAU
         5maLryppjQ6Mk35DL1kJ0627eCMwy2TzZ2WvcqqKCkwov7MVdOPdk4Jm2ntJrD96mq/i
         oxccpX6lK8j/pRwJxo6nHymfxXSUF2ie3vPBs=
MIME-Version: 1.0
In-Reply-To: <1283030397.3284.133.camel@dhcp231-106.rdu.redhat.com>
References: <1283023542-1251-1-git-send-email-csaba@gluster.com>
	<1283030397.3284.133.camel@dhcp231-106.rdu.redhat.com>
Date: Sun, 29 Aug 2010 03:20:28 +0530
X-Google-Sender-Auth: 1rGxZsIVUB5ukUHRuXEQtCn4bbI
Message-ID: <AANLkTikSRbj=omkhuZWCvoWCs86dCjETOu2z93gR5CR-@mail.gmail.com>
Subject: Re: [PATCH 1/2] fsnotify: fix NULL dereference in send_to_group()
From: Csaba Henk <csaba@gluster.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 2:49 AM, Eric Paris <eparis@redhat.com> wrote:
> This should be fixed in the pull request I sent to Linus last night.
> Sorry you had to track it down as well.  There are a number of other bug
> fixes in my tree
>
> http://git.infradead.org/users/eparis/notify.git

Oh yeah, my bad, I did check that tree before getting into this... but
only the master branch, not for-linus.

> There might still be some code duplication which something like 2/2
> could clean up but your patch does apply to my devel tree and it has a
> logic flaw.  In the case we have both a vfsmount and an inode mark we
> need to test:
>
> event_mask & vmark->mask & ~vmark->ignored_mask & ~imark->ignored mask.
>
> You would only ever test one or the other, not both together like that.

Indeed my code implements that behavior. I took care to pass the
test_mask by reference to check_mark_mask(), where upon the first
invocation it's reduced with ~imark->ignored mask, so for the second
invocation with the vmark we make test as the above expression.

If you are OK with the clean-up, I can readjust it to apply.

Csaba
