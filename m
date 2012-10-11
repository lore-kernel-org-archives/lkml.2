Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2JKO2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:28:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2JKO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:28:41 -0400
MIME-Version: 1.0
Date: Thu, 11 Oct 2012 10:28:40 -0400
Message-ID: <CAJtaB1v95Z2b78cKUPYrZtriF6BuHwD2=StyhV3gGOOquNt7fw@mail.gmail.com>
Subject: regression in bonding driver with VLAN challenged interfaces when
 8021q module is loaded
From: Jon Stanley <jstanley@rmrf.net>
To: fubar@us.ibm.com, andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit cc0e40700656b09d93b062ef6c818aa45429d09a, there is a
problem if you have the 8021q module loaded and you then attempt to
enslave a VLAN challenged interface. This is because VLAN 0 is
automatically added to the bond, and the new bond_vlan_used() function
simply checks for an empty list in bond->vlan_list without taking into
account that VLAN0 might be on the interface.

This specifically affects IPoIB interfaces in a bond if you do a
down/up cycle on the bond post-boot (during boot, the bonding module
is loaded prior to the 8021q module, so everything is fine).

Let me know if further information or testing is needed.
