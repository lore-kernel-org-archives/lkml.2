Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0GNSZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:25:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52980 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0GNSZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:25:38 -0400
Message-ID: <4C3E011A.9060007@zytor.com>
Date: Wed, 14 Jul 2010 11:25:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Ben Greear <greearb@candelatech.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 	de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>	<4C3D1F82.1040907@candelatech.com> <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com> <4C3DC64F.5040505@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com> <4C3DEEAB.8090106@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EEA18@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA8EEA18@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:19 AM, Pan, Jacob jun wrote:
> 
> I have not seen the patch yet, but there is no guarantee that
> capabilities are always laid out in ascending address. So I think
> we cannot bail out when
> 	pcie_cap >> 20 <= pos
> 
> If that is some bug in the config space, can we fix it with some quirks?
> 

I don't understand where that arithmetic comes from.

Basic config space [0-255] and extended config space [256-4095] are laid
out completely differently, and they have separate capability chains.
In theory one could have extended capabilities in basic config space,
but since the root of that chain is at 0x100, you'd have to have
extended config space available anyway in order to see it.

	-hpa
