Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1DFUFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:05:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53662 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1DFUFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iDUOtMN4RQRSKtBVd8mo8Ps/qCUovgwgLvmBXdtmKEKXiAYyNphmVUdofXCAGzxLuY
         e5uh6Ny9PBqv0nH6DQ2bjIQ7gWxeI+CeP+WEhNWHfzAC5Wv8GcL5wOfPcus6Vu3r8F9/
         i5HX0nnov6LLFmfbDAYdzbHYWSMnSjECW12BU=
MIME-Version: 1.0
In-Reply-To: <20110406.125256.102558618.davem@davemloft.net>
References: <cover.1301711868.git.lucian.grijincu@gmail.com>
 <05ae3c2fdd2db1f6a2fd3cd900164667e615f4f8.1301711868.git.lucian.grijincu@gmail.com>
 <20110406.125256.102558618.davem@davemloft.net>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Wed, 6 Apr 2011 22:04:53 +0200
Message-ID: <BANLkTik6PKYFyjnGLWoeRBrwF4sPZaaGWw@mail.gmail.com>
Subject: Re: [PATCH 01/24] sysctl: net: call unregister_net_sysctl_table where needed
To: David Miller <davem@davemloft.net>
Cc: adobriyan@gmail.com, ebiederm@xmission.com, tavi@cs.pub.ro,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 9:52 PM, David Miller <davem@davemloft.net> wrote:
> Oops, hmmm...  Can this actually cause any real problems currently?
>
> If so I'd like to toss this specific patch into net-2.6


Nope:

void unregister_net_sysctl_table(struct ctl_table_header *header)
{
        unregister_sysctl_table(header);
}
EXPORT_SYMBOL_GPL(unregister_net_sysctl_table);

But I thought that in the future, if something special needs to be
done for unregister_net_sysctl_table, it would be better to have these
consistent. I'll do a check on all the tree to see if there are other
cases.

Another approach would be to remove unregister_net_sysctl_table, as it
does nothing different of unregister_sysctl_table and let our future
selves deal with the problem.

Can you tell me what you'd like?

-- 
 .
..: Lucian
