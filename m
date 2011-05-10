Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1EJWPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:15:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1EJWPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GRjz/m2CeZewnL3JC0wU7ThKENhcEedrs2HSlRYBozXdPXqngrIp/K7+LHDeBGsz5L
         KT/6nCqaTiupAEQz2n1Q==
MIME-Version: 1.0
In-Reply-To: <1305053707.2859.57.camel@bwh-desktop>
References: <1304986748-15809-1-git-send-email-decot@google.com>
 <1304986748-15809-3-git-send-email-decot@google.com> <1305053707.2859.57.camel@bwh-desktop>
From: David Decotigny <decot@google.com>
Date: Tue, 10 May 2011 15:14:59 -0700
Message-ID: <BANLkTik5Uc8yRRHoNMENkQNeAnovLYcZjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net/dl2k: Don't reconfigure link @100Mbps when
 disabling autoneg @1Gbps
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Yes, right, I will send the updated patch together with the stmmac
update (if any).

I just hope that changing the netdev_private fields without committing
to hardware and before calling netif_carrier_off() will not create too
much confusion. I don't think so, but I still wish I could test.

Regards,

--
David Decotigny



On Tue, May 10, 2011 at 11:55 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Mon, 2011-05-09 at 17:19 -0700, David Decotigny wrote:
>> The initial version of the driver used to force the link to 100Mbps
>> when auto-negociation was disabled on a 1Gbps link, ignoring the
>> requested link speed. Instead, this change refuses to change anything
>> when it is asked to configure the link speed at 1Gbps without
>> auto-negociation, but acts as requested in all the other cases.
>>
>> IMPORTANT: Previously, the return value from mii_set_media() was
>>            ignored. This patch uses it for its own return value.
>>
>> Tested: module compiling, NOT tested on real hardware.
>> Signed-off-by: David Decotigny <decot@google.com>
> [...]
>
> The changes to validation look fine.  However, I noticed that there's a
> call to netif_carrier_off() at the top of this function.  This means
> that in the error and shortcut cases, the interface will be left
> disabled!  It's an existing bug but might be made slightly worse by this
> change.
>
> Please also move the call to netif_carrier_off() down to the end, just
> before the call to mii_set_media() which actually alters the link.
>
> Ben.
>
> --
> Ben Hutchings, Senior Software Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
>
>
