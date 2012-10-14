Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab2JNOcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:32:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37626 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2JNOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:32:40 -0400
Date: Sun, 14 Oct 2012 16:32:37 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jon Stanley <jstanley@rmrf.net>
Cc: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Subject: Re: regression in bonding driver with VLAN challenged interfaces
 when 8021q module is loaded
Message-ID: <20121014143237.GA2556@minipsycho.orion>
References: <CAJtaB1v95Z2b78cKUPYrZtriF6BuHwD2=StyhV3gGOOquNt7fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJtaB1v95Z2b78cKUPYrZtriF6BuHwD2=StyhV3gGOOquNt7fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, Oct 11, 2012 at 04:28:40PM CEST, jstanley@rmrf.net wrote:
>Since commit cc0e40700656b09d93b062ef6c818aa45429d09a, there is a
>problem if you have the 8021q module loaded and you then attempt to
>enslave a VLAN challenged interface. This is because VLAN 0 is
>automatically added to the bond, and the new bond_vlan_used() function
>simply checks for an empty list in bond->vlan_list without taking into
>account that VLAN0 might be on the interface.
>
>This specifically affects IPoIB interfaces in a bond if you do a
>down/up cycle on the bond post-boot (during boot, the bonding module
>is loaded prior to the 8021q module, so everything is fine).
>
>Let me know if further information or testing is needed.

Thanks for the report. I just fixed this by following patch:
http://patchwork.ozlabs.org/patch/191363/

