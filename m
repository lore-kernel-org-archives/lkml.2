Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2HPTKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:10:05 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55492 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2HPTKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:10:02 -0400
MIME-Version: 1.0
In-Reply-To: <2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
Date: Thu, 16 Aug 2012 15:10:01 -0400
Message-ID: <CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
Subject: Re: [RFC v2 7/7] modsig: build rules and scripts to generate keys and
 sign modules
From: Josh Boyer <jwboyer@gmail.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> This patch adds build rules and scripts to generate keys and sign modules.
>
> Two scripts has been added. genkey.sh is used to generate private and
> public keys. ksign.sh is used to sign kernel modules. Both scripts
> use only standard utilites from coreutils and additionally requires
> openssl tool for RSA keys creation and signing.
>
> The patch modifies 'modules_install' target and adds two new targets to
> the main kernel Makefile.
>
> 1. signed_modules_install
> This target creates an ephemeral key pair, signs the kernel modules with
> the private key, destroys the private key, and embeds the public key in
> the kernel. (Thanks to Dave Hansen for the target name.)

This requires CONFIG_INTEGRITY_MODULES to be enabled to actually do
anything useful with the signed modules, correct?

>
> 2. modules_install
> When CONFIG_INTEGRITY_MODULES is enabled, this target uses an existing
> private key to sign kernel modules.

If the answer to the above question is yes, then why can't we stick
with a single modules_install command for signing?  It would seem to me
that calling signed_modules_install could use an existing key or
generate an ephemeral key in the absence of one and install the signed
modules, and modules_install would simply install unsigned modules.

Or, alternatively, just make modules_install sign or not sign depending
on whether CONFIG_INTEGRITY_MODULES is enabled.  I don't see why you
would overload a target or create two different ones when both depend
on that option.

Could you explain the reasoning behind that a bit more?

josh
