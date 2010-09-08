Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0IHGOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:14:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36759 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0IHGOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I14Mr3X75FEjOgl3QMKl0uopocU4XNyght5KhO1TnuXC14MF/gvU9tYH18IglaVods
         caW0kQcTmFOJG3e1brnW/4QD4zK776w4UmIC1+v6jLYpe7vkNWs7NLuhUqGnGQES9qHE
         0EyoPqfOUwjZu8R36HBXrGluVb7AVxgsaFvBw=
MIME-Version: 1.0
In-Reply-To: <1283925324.2634.843.camel@edumazet-laptop>
References: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
	<1283923185.2634.772.camel@edumazet-laptop>
	<AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
	<1283925324.2634.843.camel@edumazet-laptop>
Date: Wed, 8 Sep 2010 14:14:42 +0800
Message-ID: <AANLkTikfhz4AQntX2o5sSQy67TWb=rYqEjsoA2ju+Ycq@mail.gmail.com>
Subject: Re: [PATCH] netlink: Fix kfree NULL pointer
From: jovi zhang <bookjovi@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 1:55 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 08 septembre 2010 à 13:33 +0800, jovi zhang a écrit :
>
>> YES, maybe kfree(NULL) is legal, but I cannot see there have any need
>> to invoke kfree(NULL) in this function.
>>  Also I check kfree usage in other code, I havn't find any kfree(NULL) usage.
>
> We have hundred call sites doing kfree(NULL), if it makes code shorter.
>
> Its usually code path handling exceptions (errors if you prefer), and we
> prefer to use ugly gotos, and even kfree(NULL), to make it as short as
> possible.

OK, I understand.
