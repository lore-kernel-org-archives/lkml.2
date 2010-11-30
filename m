Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0K3NgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:36:15 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54045 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0K3NgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:36:14 -0500
X-Greylist: delayed 998 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 08:36:14 EST
Subject: Re: [PATCH] DOCUMENTATION: Correct inline docs to match parm name.
From: Paul Bolle <pebolle@tiscali.nl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 30 Nov 2010 14:19:29 +0100
In-Reply-To: <alpine.DEB.2.00.1011300629580.21294@localhost6.localdomain6>
References: <alpine.DEB.2.00.1011300629580.21294@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.2 (2.91.2-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1291123175.1992.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 06:31 -0500, Robert P. J. Day wrote:
> @@ -1485,7 +1485,7 @@ out:
>  /**
>   * d_validate - verify dentry provided from insecure source
>   * @dentry: The dentry alleged to be valid child of @dparent

Doesn't this one needs to be changed too?

> - * @dparent: The parent dentry (known to be valid)
> + * @parent: The parent dentry (known to be valid)
>   *
>   * An insecure source has sent us a dentry, here we verify it and dget() it.
>   * This is used by ncpfs in its readdir implementation.

By the way, the code currently reads:

int d_validate(struct dentry *dentry, struct dentry *parent)
{
[...]
        rcu_read_lock();
        hlist_for_each_entry_rcu(d, node, head, d_hash) {
                if (d == dentry) {
                        dget(dentry);
                        return 1;
                }
        }
        rcu_read_unlock();
        return 0;
}

I know nothing about rcu_read_lock(), but why is there no
rcu_read_unlock() before the "return 1" case?


Paul Bolle

