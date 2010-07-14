Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0GNSrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:47:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33806 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab0GNSrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:47:40 -0400
Message-ID: <4C3E0641.4020706@zytor.com>
Date: Wed, 14 Jul 2010 11:47:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 	de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>	<4C3D1F82.1040907@candelatech.com> <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com> <4C3DC64F.5040505@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com> <4C3DEEAB.8090106@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EEA18@orsmsx508.amr.corp.intel.com> <4C3E0073.7070302@candelatech.com>
In-Reply-To: <4C3E0073.7070302@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:22 AM, Ben Greear wrote:
> 
> Is there at least a maximum number of capabilities that can exist so that
> you can limit the loop by that?
> 

Well, 3072 bytes and a minimum size of 4 bytes, so 768.  However, a
capability ID of 0000 or FFFF means no capabilities (PCIe 2.01 sec
7.9.1-2), so we should terminate the search on finding one of those
capability ID.

[Also note: bits 21:20 are reserved and need to be masked, per PCIe 2.01
7.9.3.]

The spec seems to imply that capabilities should be sequential, but I
really don't know if that is actually the case in the field.

	-hpa
