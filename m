Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1KVOXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:23:43 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:36251 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab1KVOXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:23:41 -0500
X-Authenticated-User: konrad.gaisler.com
Message-ID: <4ECBAEB2.4050003@gaisler.com>
Date: Tue, 22 Nov 2011 15:16:18 +0100
From: Konrad Eisele <konrad@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Konrad Eisele <konrad@gaisler.com>
CC: linux-kernel@vger.kernel.org, lacombar@gmail.com, mmarek@suse.cz,
        yann.morin.1998@anciens.enib.fr, linux-config@vger.kernel.org
Subject: Re: [PATCH 0/3] intro
References: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com> <1321970626-12615-1-git-send-email-konrad@gaisler.com>
In-Reply-To: <1321970626-12615-1-git-send-email-konrad@gaisler.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=vjffymXyDtjo34N5cbiAavWp8ckkCSHNaVzdIDazEXU= c=1 sm=1
		a=CIB-vgOadyEA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=gV6sQqG_dtQ6NNyGBioA:9 a=wPNLvfGTeEIA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Eisele wrote:
> [PATCH 1/3] kconfig: Move global elements into struct, create root context
>   remove globals and create seperate namespaces. The default namespace is
>   &rootlevel.
> 
> [PATCH 2/3] kconfig: Add support for Kconfig subtrees
>   This adds subtree support, added Documentation/kbuild/kconfig-language.txt
>   lines that describe the fix
> 
> [PATCH 3/3] kconfig: gconfig save button should be greyed if no changes present
>   in gconfig the save button is always active eaven with no changes present.
> 
> 

The patches are against: 15bd1cfb3055d866614cdaf38e43201936264e50

To test do:
1. <apply patches>
2. $touch scripts/kconfig/zconf.y scripts/kconfig/zconf.l scripts/kconfig/zconf.gperf
3. <apply the below diff to toplevel Kconfig>
4. $make REGENERATE_PARSERS=1 HOSTCFLAGS=-g xconfig

Then you'll see a "SPARC subtree" subtree in qconfig.

-- Konrad


diff --git a/Kconfig b/Kconfig
index c13f48d..fa22448 100644
--- a/Kconfig
+++ b/Kconfig
@@ -9,3 +9,10 @@ config SRCARCH
        option env="SRCARCH"

 source "arch/$SRCARCH/Kconfig"
+
+menu "SPARC subtree"
+  prefix "CONFIG_"
+
+source "arch/sparc/Kconfig"
+
+endmenu
d
