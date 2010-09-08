Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab0IHFzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:55:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0IHFza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sNTKmQMGKUZ6cC3sw0uZ90nK/vu9AexCfFU3dCJtcgeX6RpahzXq48DLEjRW1nvEDy
         hycAydMUHJkBZcr7S5cYiSMEG/4Mtnmeq1/b4n/wWLZB1dhy0Hsc6n3AvhoSKMHbpmVC
         K8OBZIg8XhdeOXa+n5PkaMmRtuoeriQC9Bxk4=
Subject: Re: [PATCH] netlink: Fix kfree NULL pointer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
References: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
	 <1283923185.2634.772.camel@edumazet-laptop>
	 <AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 07:55:24 +0200
Message-ID: <1283925324.2634.843.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 septembre 2010 à 13:33 +0800, jovi zhang a écrit :

> YES, maybe kfree(NULL) is legal, but I cannot see there have any need
> to invoke kfree(NULL) in this function.
>  Also I check kfree usage in other code, I havn't find any kfree(NULL) usage.

We have hundred call sites doing kfree(NULL), if it makes code shorter.

Its usually code path handling exceptions (errors if you prefer), and we
prefer to use ugly gotos, and even kfree(NULL), to make it as short as
possible.



