Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0JDXKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:10:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:52030 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0JDXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:10:23 -0400
Subject: Re: [PATCH] Globally s/struct irq_host/struct irq_domain/
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jon Loeliger <jdl@jdl.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de
In-Reply-To: <20101004165212.GC13749@angua.secretlab.ca>
References: <E1P2Tqn-0004gj-W1@jdl.com>
	 <20101004165212.GC13749@angua.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 10:09:36 +1100
Message-ID: <1286233776.2463.329.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 10:52 -0600, Grant Likely wrote:
> On Sun, Oct 03, 2010 at 02:03:57PM -0500, Jon Loeliger wrote:
> > 
> > Just rename the irq_host structure as irq_domain to lessen the
> > confusion around the word "host".  Updated a few comments and
> > error messages to use "irq_domain" when refering to the structure.
> > 
> > Suggested by Ben Herrenschmidt on the device-tree mailing list.
> > 
> > Signed-off-by: Jon Loeliger <jdl@jdl.com>
> > ---
> > 
> > Grant requested one giant patch simply renaming the structure.
> 
> Thanks Jon,
> 
> However, considering that tglx has already embarked on his Grand IRQ
> Subsystem Cleanup, I suspect that this will end up just getting in the
> way unless he picks it up into his queue.  It may even by that the
> need for irq_host will disappear once Thomas is finished by merging it
> into the core code.  I'd like to sit tight on this until the details
> of what powerpc virqs can be worked out with Ben and Thomas.

I doubt the need for irq_host will disappear. However I don't see that
going into the core under that name, so I think the rename is a very
valid thing to do now. We just need to sync the patches to avoid pure
mechanical clash.

Thomas initial series doesn't yet generalize the virq layer and that
will take a bit longer, so I'm happy to see Jon stuff go upstream first.

What hopefully will go away is the big irq_map array, I hope to put the
domain & hw_number information in the irq_desc or irq_data eventually.

> Also, sorry for sending you down this rabbit hole.  When I suggested
> this I didn't realize how quickly Thomas was going to get started on
> his rework.

Cheers,
Ben.

> g.
> 
> > 
> > 
> >  arch/microblaze/include/asm/irq.h                |    4 +-
> >  arch/microblaze/kernel/irq.c                     |    2 +-
> >  arch/powerpc/include/asm/i8259.h                 |    2 +-
> >  arch/powerpc/include/asm/irq.h                   |   40 +++++++++++-----------
> >  arch/powerpc/include/asm/mpic.h                  |    2 +-
> >  arch/powerpc/kernel/irq.c                        |   40 +++++++++++-----------
> >  arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    6 ++--
> >  arch/powerpc/platforms/52xx/media5200.c          |    6 ++--
> >  arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    8 ++--
> >  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |    6 ++--
> >  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    8 ++--
> >  arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |    8 ++--
> >  arch/powerpc/platforms/86xx/gef_pic.c            |    8 ++--
> >  arch/powerpc/platforms/cell/axon_msi.c           |   10 +++---
> >  arch/powerpc/platforms/cell/beat_interrupt.c     |   12 +++---
> >  arch/powerpc/platforms/cell/interrupt.c          |   10 +++---
> >  arch/powerpc/platforms/cell/spider-pic.c         |    6 ++--
> >  arch/powerpc/platforms/embedded6xx/flipper-pic.c |   14 ++++----
> >  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   18 +++++-----
> >  arch/powerpc/platforms/iseries/irq.c             |    6 ++--
> >  arch/powerpc/platforms/powermac/pic.c            |    8 ++--
> >  arch/powerpc/platforms/ps3/interrupt.c           |    8 ++--
> >  arch/powerpc/platforms/pseries/xics.c            |    8 ++--
> >  arch/powerpc/sysdev/cpm1.c                       |    4 +-
> >  arch/powerpc/sysdev/cpm2_pic.c                   |    6 ++--
> >  arch/powerpc/sysdev/fsl_msi.c                    |    2 +-
> >  arch/powerpc/sysdev/fsl_msi.h                    |    2 +-
> >  arch/powerpc/sysdev/i8259.c                      |   12 +++---
> >  arch/powerpc/sysdev/ipic.c                       |    6 ++--
> >  arch/powerpc/sysdev/ipic.h                       |    2 +-
> >  arch/powerpc/sysdev/mpc8xx_pic.c                 |    6 ++--
> >  arch/powerpc/sysdev/mpc8xxx_gpio.c               |    6 ++--
> >  arch/powerpc/sysdev/mpic.c                       |    6 ++--
> >  arch/powerpc/sysdev/mv64x60_pic.c                |    4 +-
> >  arch/powerpc/sysdev/qe_lib/qe_ic.c               |    6 ++--
> >  arch/powerpc/sysdev/qe_lib/qe_ic.h               |    2 +-
> >  arch/powerpc/sysdev/tsi108_pci.c                 |    6 ++--
> >  arch/powerpc/sysdev/uic.c                        |    6 ++--
> >  arch/powerpc/sysdev/xilinx_intc.c                |   12 +++---
> >  39 files changed, 164 insertions(+), 164 deletions(-)
> > 
> > diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
> > index ec5583d..8ef92dd 100644
> > --- a/arch/microblaze/include/asm/irq.h
> > +++ b/arch/microblaze/include/asm/irq.h
> > @@ -36,7 +36,7 @@ static inline void irq_dispose_mapping(unsigned int virq)
> >  	return;
> >  }
> >  
> > -struct irq_host;
> > +struct irq_domain;
> >  
> >  /**
> >   * irq_create_mapping - Map a hardware interrupt into linux virq space
> > @@ -48,7 +48,7 @@ struct irq_host;
> >   * If the sense/trigger is to be specified, set_irq_type() should be called
> >   * on the number returned from that call.
> >   */
> > -extern unsigned int irq_create_mapping(struct irq_host *host,
> > +extern unsigned int irq_create_mapping(struct irq_domain *host,
> >  					irq_hw_number_t hwirq);
> >  
> >  #endif /* _ASM_MICROBLAZE_IRQ_H */
> > diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
> > index a9345fb..059bb11 100644
> > --- a/arch/microblaze/kernel/irq.c
> > +++ b/arch/microblaze/kernel/irq.c
> > @@ -89,7 +89,7 @@ skip:
> >  
> >  /* MS: There is no any advance mapping mechanism. We are using simple 32bit
> >    intc without any cascades or any connection that's why mapping is 1:1 */
> > -unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
> > +unsigned int irq_create_mapping(struct irq_domain *host, irq_hw_number_t hwirq)
> >  {
> >  	return hwirq;
> >  }
> > diff --git a/arch/powerpc/include/asm/i8259.h b/arch/powerpc/include/asm/i8259.h
> > index 105ade2..c3fdfbd 100644
> > --- a/arch/powerpc/include/asm/i8259.h
> > +++ b/arch/powerpc/include/asm/i8259.h
> > @@ -6,7 +6,7 @@
> >  
> >  extern void i8259_init(struct device_node *node, unsigned long intack_addr);
> >  extern unsigned int i8259_irq(void);
> > -extern struct irq_host *i8259_get_host(void);
> > +extern struct irq_domain *i8259_get_host(void);
> >  
> >  #endif /* __KERNEL__ */
> >  #endif /* _ASM_POWERPC_I8259_H */
> > diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
> > index 67ab5fb..3e25340 100644
> > --- a/arch/powerpc/include/asm/irq.h
> > +++ b/arch/powerpc/include/asm/irq.h
> > @@ -66,7 +66,7 @@ typedef unsigned long irq_hw_number_t;
> >   * by some sort of arch-specific void * "token" used to identify interrupt
> >   * controllers.
> >   */
> > -struct irq_host;
> > +struct irq_domain;
> >  struct radix_tree_root;
> >  
> >  /* Functions below are provided by the host and called whenever a new mapping
> > @@ -78,18 +78,18 @@ struct irq_host_ops {
> >  	/* Match an interrupt controller device node to a host, returns
> >  	 * 1 on a match
> >  	 */
> > -	int (*match)(struct irq_host *h, struct device_node *node);
> > +	int (*match)(struct irq_domain *h, struct device_node *node);
> >  
> >  	/* Create or update a mapping between a virtual irq number and a hw
> >  	 * irq number. This is called only once for a given mapping.
> >  	 */
> > -	int (*map)(struct irq_host *h, unsigned int virq, irq_hw_number_t hw);
> > +	int (*map)(struct irq_domain *h, unsigned int virq, irq_hw_number_t hw);
> >  
> >  	/* Dispose of such a mapping */
> > -	void (*unmap)(struct irq_host *h, unsigned int virq);
> > +	void (*unmap)(struct irq_domain *h, unsigned int virq);
> >  
> >  	/* Update of such a mapping  */
> > -	void (*remap)(struct irq_host *h, unsigned int virq, irq_hw_number_t hw);
> > +	void (*remap)(struct irq_domain *h, unsigned int virq, irq_hw_number_t hw);
> >  
> >  	/* Translate device-tree interrupt specifier from raw format coming
> >  	 * from the firmware to a irq_hw_number_t (interrupt line number) and
> > @@ -99,12 +99,12 @@ struct irq_host_ops {
> >  	 * the type (which amount to keeping whatever default value the
> >  	 * interrupt controller has for that line)
> >  	 */
> > -	int (*xlate)(struct irq_host *h, struct device_node *ctrler,
> > +	int (*xlate)(struct irq_domain *h, struct device_node *ctrler,
> >  		     const u32 *intspec, unsigned int intsize,
> >  		     irq_hw_number_t *out_hwirq, unsigned int *out_type);
> >  };
> >  
> > -struct irq_host {
> > +struct irq_domain {
> >  	struct list_head	link;
> >  
> >  	/* type of reverse mapping technique */
> > @@ -135,7 +135,7 @@ struct irq_host {
> >   */
> >  struct irq_map_entry {
> >  	irq_hw_number_t	hwirq;
> > -	struct irq_host	*host;
> > +	struct irq_domain	*host;
> >  };
> >  
> >  extern struct irq_map_entry irq_map[NR_IRQS];
> > @@ -143,14 +143,14 @@ extern struct irq_map_entry irq_map[NR_IRQS];
> >  extern irq_hw_number_t virq_to_hw(unsigned int virq);
> >  
> >  /**
> > - * irq_alloc_host - Allocate a new irq_host data structure
> > + * irq_alloc_host - Allocate a new irq_domain data structure
> >   * @of_node: optional device-tree node of the interrupt controller
> >   * @revmap_type: type of reverse mapping to use
> >   * @revmap_arg: for IRQ_HOST_MAP_LINEAR linear only: size of the map
> >   * @ops: map/unmap host callbacks
> >   * @inval_irq: provide a hw number in that host space that is always invalid
> >   *
> > - * Allocates and initialize and irq_host structure. Note that in the case of
> > + * Allocates and initialize and irq_domain structure. Note that in the case of
> >   * IRQ_HOST_MAP_LEGACY, the map() callback will be called before this returns
> >   * for all legacy interrupts except 0 (which is always the invalid irq for
> >   * a legacy controller). For a IRQ_HOST_MAP_LINEAR, the map is allocated by
> > @@ -158,7 +158,7 @@ extern irq_hw_number_t virq_to_hw(unsigned int virq);
> >   * later during boot automatically (the reverse mapping will use the slow path
> >   * until that happens).
> >   */
> > -extern struct irq_host *irq_alloc_host(struct device_node *of_node,
> > +extern struct irq_domain *irq_alloc_host(struct device_node *of_node,
> >  				       unsigned int revmap_type,
> >  				       unsigned int revmap_arg,
> >  				       struct irq_host_ops *ops,
> > @@ -169,7 +169,7 @@ extern struct irq_host *irq_alloc_host(struct device_node *of_node,
> >   * irq_find_host - Locates a host for a given device node
> >   * @node: device-tree node of the interrupt controller
> >   */
> > -extern struct irq_host *irq_find_host(struct device_node *node);
> > +extern struct irq_domain *irq_find_host(struct device_node *node);
> >  
> >  
> >  /**
> > @@ -181,7 +181,7 @@ extern struct irq_host *irq_find_host(struct device_node *node);
> >   * platforms that want to manipulate a few hard coded interrupt numbers that
> >   * aren't properly represented in the device-tree.
> >   */
> > -extern void irq_set_default_host(struct irq_host *host);
> > +extern void irq_set_default_host(struct irq_domain *host);
> >  
> >  
> >  /**
> > @@ -204,7 +204,7 @@ extern void irq_set_virq_count(unsigned int count);
> >   * If the sense/trigger is to be specified, set_irq_type() should be called
> >   * on the number returned from that call.
> >   */
> > -extern unsigned int irq_create_mapping(struct irq_host *host,
> > +extern unsigned int irq_create_mapping(struct irq_domain *host,
> >  				       irq_hw_number_t hwirq);
> >  
> >  
> > @@ -223,7 +223,7 @@ extern void irq_dispose_mapping(unsigned int virq);
> >   * irq controller implementation directly calls the appropriate low level
> >   * mapping function.
> >   */
> > -extern unsigned int irq_find_mapping(struct irq_host *host,
> > +extern unsigned int irq_find_mapping(struct irq_domain *host,
> >  				     irq_hw_number_t hwirq);
> >  
> >  /**
> > @@ -234,7 +234,7 @@ extern unsigned int irq_find_mapping(struct irq_host *host,
> >   * interrupt numbers they generate. In such a case it's simplest to use
> >   * the linux virq as the hardware interrupt number.
> >   */
> > -extern unsigned int irq_create_direct_mapping(struct irq_host *host);
> > +extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
> >  
> >  /**
> >   * irq_radix_revmap_insert - Insert a hw irq to linux virq number mapping.
> > @@ -245,7 +245,7 @@ extern unsigned int irq_create_direct_mapping(struct irq_host *host);
> >   * This is for use by irq controllers that use a radix tree reverse
> >   * mapping for fast lookup.
> >   */
> > -extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> > +extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
> >  				    irq_hw_number_t hwirq);
> >  
> >  /**
> > @@ -256,7 +256,7 @@ extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> >   * This is a fast path, for use by irq controller code that uses radix tree
> >   * revmaps
> >   */
> > -extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> > +extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
> >  					    irq_hw_number_t hwirq);
> >  
> >  /**
> > @@ -269,7 +269,7 @@ extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> >   * yet and will create the revmap entry with appropriate locking
> >   */
> >  
> > -extern unsigned int irq_linear_revmap(struct irq_host *host,
> > +extern unsigned int irq_linear_revmap(struct irq_domain *host,
> >  				      irq_hw_number_t hwirq);
> >  
> >  
> > @@ -284,7 +284,7 @@ extern unsigned int irq_linear_revmap(struct irq_host *host,
> >   * and that can be used by some irq controllers implementations for things
> >   * like allocating ranges of numbers for MSIs. The revmaps are left untouched.
> >   */
> > -extern unsigned int irq_alloc_virt(struct irq_host *host,
> > +extern unsigned int irq_alloc_virt(struct irq_domain *host,
> >  				   unsigned int count,
> >  				   unsigned int hint);
> >  
> > diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
> > index e000cce..18d07da 100644
> > --- a/arch/powerpc/include/asm/mpic.h
> > +++ b/arch/powerpc/include/asm/mpic.h
> > @@ -253,7 +253,7 @@ struct mpic_irq_save {
> >  struct mpic
> >  {
> >  	/* The remapper for this MPIC */
> > -	struct irq_host		*irqhost;
> > +	struct irq_domain	*irqhost;
> >  
> >  	/* The "linux" controller struct */
> >  	struct irq_chip		hc_irq;
> > diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> > index 4a65386..60ec363 100644
> > --- a/arch/powerpc/kernel/irq.c
> > +++ b/arch/powerpc/kernel/irq.c
> > @@ -533,7 +533,7 @@ static unsigned int revmap_trees_allocated;
> >  static DEFINE_MUTEX(revmap_trees_mutex);
> >  struct irq_map_entry irq_map[NR_IRQS];
> >  static unsigned int irq_virq_count = NR_IRQS;
> > -static struct irq_host *irq_default_host;
> > +static struct irq_domain *irq_default_host;
> >  
> >  irq_hw_number_t virq_to_hw(unsigned int virq)
> >  {
> > @@ -541,19 +541,19 @@ irq_hw_number_t virq_to_hw(unsigned int virq)
> >  }
> >  EXPORT_SYMBOL_GPL(virq_to_hw);
> >  
> > -static int default_irq_host_match(struct irq_host *h, struct device_node *np)
> > +static int default_irq_host_match(struct irq_domain *h, struct device_node *np)
> >  {
> >  	return h->of_node != NULL && h->of_node == np;
> >  }
> >  
> > -struct irq_host *irq_alloc_host(struct device_node *of_node,
> > +struct irq_domain *irq_alloc_host(struct device_node *of_node,
> >  				unsigned int revmap_type,
> >  				unsigned int revmap_arg,
> >  				struct irq_host_ops *ops,
> >  				irq_hw_number_t inval_irq)
> >  {
> > -	struct irq_host *host;
> > -	unsigned int size = sizeof(struct irq_host);
> > +	struct irq_domain *host;
> > +	unsigned int size = sizeof(struct irq_domain);
> >  	unsigned int i;
> >  	unsigned int *rmap;
> >  	unsigned long flags;
> > @@ -636,9 +636,9 @@ struct irq_host *irq_alloc_host(struct device_node *of_node,
> >  	return host;
> >  }
> >  
> > -struct irq_host *irq_find_host(struct device_node *node)
> > +struct irq_domain *irq_find_host(struct device_node *node)
> >  {
> > -	struct irq_host *h, *found = NULL;
> > +	struct irq_domain *h, *found = NULL;
> >  	unsigned long flags;
> >  
> >  	/* We might want to match the legacy controller last since
> > @@ -657,7 +657,7 @@ struct irq_host *irq_find_host(struct device_node *node)
> >  }
> >  EXPORT_SYMBOL_GPL(irq_find_host);
> >  
> > -void irq_set_default_host(struct irq_host *host)
> > +void irq_set_default_host(struct irq_domain *host)
> >  {
> >  	pr_debug("irq: Default host set to @0x%p\n", host);
> >  
> > @@ -673,7 +673,7 @@ void irq_set_virq_count(unsigned int count)
> >  		irq_virq_count = count;
> >  }
> >  
> > -static int irq_setup_virq(struct irq_host *host, unsigned int virq,
> > +static int irq_setup_virq(struct irq_domain *host, unsigned int virq,
> >  			    irq_hw_number_t hwirq)
> >  {
> >  	struct irq_desc *desc;
> > @@ -704,7 +704,7 @@ error:
> >  	return -1;
> >  }
> >  
> > -unsigned int irq_create_direct_mapping(struct irq_host *host)
> > +unsigned int irq_create_direct_mapping(struct irq_domain *host)
> >  {
> >  	unsigned int virq;
> >  
> > @@ -728,7 +728,7 @@ unsigned int irq_create_direct_mapping(struct irq_host *host)
> >  	return virq;
> >  }
> >  
> > -unsigned int irq_create_mapping(struct irq_host *host,
> > +unsigned int irq_create_mapping(struct irq_domain *host,
> >  				irq_hw_number_t hwirq)
> >  {
> >  	unsigned int virq, hint;
> > @@ -787,7 +787,7 @@ EXPORT_SYMBOL_GPL(irq_create_mapping);
> >  unsigned int irq_create_of_mapping(struct device_node *controller,
> >  				   const u32 *intspec, unsigned int intsize)
> >  {
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  	irq_hw_number_t hwirq;
> >  	unsigned int type = IRQ_TYPE_NONE;
> >  	unsigned int virq;
> > @@ -826,7 +826,7 @@ EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> >  
> >  void irq_dispose_mapping(unsigned int virq)
> >  {
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  	irq_hw_number_t hwirq;
> >  
> >  	if (virq == NO_IRQ)
> > @@ -885,7 +885,7 @@ void irq_dispose_mapping(unsigned int virq)
> >  }
> >  EXPORT_SYMBOL_GPL(irq_dispose_mapping);
> >  
> > -unsigned int irq_find_mapping(struct irq_host *host,
> > +unsigned int irq_find_mapping(struct irq_domain *host,
> >  			      irq_hw_number_t hwirq)
> >  {
> >  	unsigned int i;
> > @@ -918,7 +918,7 @@ unsigned int irq_find_mapping(struct irq_host *host,
> >  EXPORT_SYMBOL_GPL(irq_find_mapping);
> >  
> >  
> > -unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> > +unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
> >  				     irq_hw_number_t hwirq)
> >  {
> >  	struct irq_map_entry *ptr;
> > @@ -953,7 +953,7 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
> >  	return virq;
> >  }
> >  
> > -void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> > +void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
> >  			     irq_hw_number_t hwirq)
> >  {
> >  
> > @@ -976,7 +976,7 @@ void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
> >  	}
> >  }
> >  
> > -unsigned int irq_linear_revmap(struct irq_host *host,
> > +unsigned int irq_linear_revmap(struct irq_domain *host,
> >  			       irq_hw_number_t hwirq)
> >  {
> >  	unsigned int *revmap;
> > @@ -999,7 +999,7 @@ unsigned int irq_linear_revmap(struct irq_host *host,
> >  	return revmap[hwirq];
> >  }
> >  
> > -unsigned int irq_alloc_virt(struct irq_host *host,
> > +unsigned int irq_alloc_virt(struct irq_domain *host,
> >  			    unsigned int count,
> >  			    unsigned int hint)
> >  {
> > @@ -1056,7 +1056,7 @@ void irq_free_virt(unsigned int virq, unsigned int count)
> >  
> >  	raw_spin_lock_irqsave(&irq_big_lock, flags);
> >  	for (i = virq; i < (virq + count); i++) {
> > -		struct irq_host *host;
> > +		struct irq_domain *host;
> >  
> >  		if (i < NUM_ISA_INTERRUPTS ||
> >  		    (virq + count) > irq_virq_count)
> > @@ -1093,7 +1093,7 @@ int arch_init_chip_data(struct irq_desc *desc, int node)
> >  /* We need to create the radix trees late */
> >  static int irq_late_init(void)
> >  {
> > -	struct irq_host *h;
> > +	struct irq_domain *h;
> >  	unsigned int i;
> >  
> >  	/*
> > diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
> > index 4ecf4cf..32e784e 100644
> > --- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
> > +++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
> > @@ -21,7 +21,7 @@
> >  #include <asm/prom.h>
> >  
> >  static struct device_node *cpld_pic_node;
> > -static struct irq_host *cpld_pic_host;
> > +static struct irq_domain *cpld_pic_host;
> >  
> >  /*
> >   * Bits to ignore in the misc_status register
> > @@ -123,13 +123,13 @@ cpld_pic_cascade(unsigned int irq, struct irq_desc *desc)
> >  }
> >  
> >  static int
> > -cpld_pic_host_match(struct irq_host *h, struct device_node *node)
> > +cpld_pic_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	return cpld_pic_node == node;
> >  }
> >  
> >  static int
> > -cpld_pic_host_map(struct irq_host *h, unsigned int virq,
> > +cpld_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			     irq_hw_number_t hw)
> >  {
> >  	irq_to_desc(virq)->status |= IRQ_LEVEL;
> > diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
> > index 0bac3a3..4dae3fd 100644
> > --- a/arch/powerpc/platforms/52xx/media5200.c
> > +++ b/arch/powerpc/platforms/52xx/media5200.c
> > @@ -45,7 +45,7 @@ static struct of_device_id mpc5200_gpio_ids[] __initdata = {
> >  struct media5200_irq {
> >  	void __iomem *regs;
> >  	spinlock_t lock;
> > -	struct irq_host *irqhost;
> > +	struct irq_domain *irqhost;
> >  };
> >  struct media5200_irq media5200_irq;
> >  
> > @@ -111,7 +111,7 @@ void media5200_irq_cascade(unsigned int virq, struct irq_desc *desc)
> >  	raw_spin_unlock(&desc->lock);
> >  }
> >  
> > -static int media5200_irq_map(struct irq_host *h, unsigned int virq,
> > +static int media5200_irq_map(struct irq_domain *h, unsigned int virq,
> >  			     irq_hw_number_t hw)
> >  {
> >  	struct irq_desc *desc = irq_to_desc(virq);
> > @@ -126,7 +126,7 @@ static int media5200_irq_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int media5200_irq_xlate(struct irq_host *h, struct device_node *ct,
> > +static int media5200_irq_xlate(struct irq_domain *h, struct device_node *ct,
> >  				 const u32 *intspec, unsigned int intsize,
> >  				 irq_hw_number_t *out_hwirq,
> >  				 unsigned int *out_flags)
> > diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> > index fea833e..dccec6d 100644
> > --- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> > +++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> > @@ -79,7 +79,7 @@ MODULE_LICENSE("GPL");
> >   * @regs: virtual address of GPT registers
> >   * @lock: spinlock to coordinate between different functions.
> >   * @gc: gpio_chip instance structure; used when GPIO is enabled
> > - * @irqhost: Pointer to irq_host instance; used when IRQ mode is supported
> > + * @irqhost: Pointer to irq_domain instance; used when IRQ mode is supported
> >   * @wdt_mode: only relevant for gpt0: bit 0 (MPC52xx_GPT_CAN_WDT) indicates
> >   *   if the gpt may be used as wdt, bit 1 (MPC52xx_GPT_IS_WDT) indicates
> >   *   if the timer is actively used as wdt which blocks gpt functions
> > @@ -89,7 +89,7 @@ struct mpc52xx_gpt_priv {
> >  	struct device *dev;
> >  	struct mpc52xx_gpt __iomem *regs;
> >  	spinlock_t lock;
> > -	struct irq_host *irqhost;
> > +	struct irq_domain *irqhost;
> >  	u32 ipb_freq;
> >  	u8 wdt_mode;
> >  
> > @@ -202,7 +202,7 @@ void mpc52xx_gpt_irq_cascade(unsigned int virq, struct irq_desc *desc)
> >  	}
> >  }
> >  
> > -static int mpc52xx_gpt_irq_map(struct irq_host *h, unsigned int virq,
> > +static int mpc52xx_gpt_irq_map(struct irq_domain *h, unsigned int virq,
> >  			       irq_hw_number_t hw)
> >  {
> >  	struct mpc52xx_gpt_priv *gpt = h->host_data;
> > @@ -214,7 +214,7 @@ static int mpc52xx_gpt_irq_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int mpc52xx_gpt_irq_xlate(struct irq_host *h, struct device_node *ct,
> > +static int mpc52xx_gpt_irq_xlate(struct irq_domain *h, struct device_node *ct,
> >  				 const u32 *intspec, unsigned int intsize,
> >  				 irq_hw_number_t *out_hwirq,
> >  				 unsigned int *out_flags)
> > diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> > index 4bf4bf7..7d83308 100644
> > --- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> > +++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> > @@ -132,7 +132,7 @@ static struct of_device_id mpc52xx_sdma_ids[] __initdata = {
> >  
> >  static struct mpc52xx_intr __iomem *intr;
> >  static struct mpc52xx_sdma __iomem *sdma;
> > -static struct irq_host *mpc52xx_irqhost = NULL;
> > +static struct irq_domain *mpc52xx_irqhost = NULL;
> >  
> >  static unsigned char mpc52xx_map_senses[4] = {
> >  	IRQ_TYPE_LEVEL_HIGH,
> > @@ -354,7 +354,7 @@ static int mpc52xx_is_extirq(int l1, int l2)
> >  /**
> >   * mpc52xx_irqhost_xlate - translate virq# from device tree interrupts property
> >   */
> > -static int mpc52xx_irqhost_xlate(struct irq_host *h, struct device_node *ct,
> > +static int mpc52xx_irqhost_xlate(struct irq_domain *h, struct device_node *ct,
> >  				 const u32 *intspec, unsigned int intsize,
> >  				 irq_hw_number_t *out_hwirq,
> >  				 unsigned int *out_flags)
> > @@ -388,7 +388,7 @@ static int mpc52xx_irqhost_xlate(struct irq_host *h, struct device_node *ct,
> >  /**
> >   * mpc52xx_irqhost_map - Hook to map from virq to an irq_chip structure
> >   */
> > -static int mpc52xx_irqhost_map(struct irq_host *h, unsigned int virq,
> > +static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
> >  			       irq_hw_number_t irq)
> >  {
> >  	int l1irq;
> > diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> > index 5a55d87..47b8d5d 100644
> > --- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> > +++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> > @@ -29,7 +29,7 @@ static DEFINE_RAW_SPINLOCK(pci_pic_lock);
> >  
> >  struct pq2ads_pci_pic {
> >  	struct device_node *node;
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  
> >  	struct {
> >  		u32 stat;
> > @@ -104,7 +104,7 @@ static void pq2ads_pci_irq_demux(unsigned int irq, struct irq_desc *desc)
> >  	}
> >  }
> >  
> > -static int pci_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int pci_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			    irq_hw_number_t hw)
> >  {
> >  	irq_to_desc(virq)->status |= IRQ_LEVEL;
> > @@ -113,7 +113,7 @@ static int pci_pic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static void pci_host_unmap(struct irq_host *h, unsigned int virq)
> > +static void pci_host_unmap(struct irq_domain *h, unsigned int virq)
> >  {
> >  	/* remove chip and handler */
> >  	set_irq_chip_data(virq, NULL);
> > @@ -128,7 +128,7 @@ static struct irq_host_ops pci_pic_host_ops = {
> >  int __init pq2ads_pci_init_irq(void)
> >  {
> >  	struct pq2ads_pci_pic *priv;
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  	struct device_node *np;
> >  	int ret = -ENODEV;
> >  	int irq;
> > diff --git a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
> > index d48527f..fe51afe 100644
> > --- a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
> > +++ b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
> > @@ -53,7 +53,7 @@ static struct socrates_fpga_irq_info fpga_irqs[SOCRATES_FPGA_NUM_IRQS] = {
> >  static DEFINE_RAW_SPINLOCK(socrates_fpga_pic_lock);
> >  
> >  static void __iomem *socrates_fpga_pic_iobase;
> > -static struct irq_host *socrates_fpga_pic_irq_host;
> > +static struct irq_domain *socrates_fpga_pic_irq_host;
> >  static unsigned int socrates_fpga_irqs[3];
> >  
> >  static inline uint32_t socrates_fpga_pic_read(int reg)
> > @@ -241,7 +241,7 @@ static struct irq_chip socrates_fpga_pic_chip = {
> >  	.set_type	= socrates_fpga_pic_set_type,
> >  };
> >  
> > -static int socrates_fpga_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int socrates_fpga_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  		irq_hw_number_t hwirq)
> >  {
> >  	/* All interrupts are LEVEL sensitive */
> > @@ -252,7 +252,7 @@ static int socrates_fpga_pic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int socrates_fpga_pic_host_xlate(struct irq_host *h,
> > +static int socrates_fpga_pic_host_xlate(struct irq_domain *h,
> >  		struct device_node *ct,	const u32 *intspec, unsigned int intsize,
> >  		irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  {
> > @@ -293,7 +293,7 @@ void socrates_fpga_pic_init(struct device_node *pic)
> >  	unsigned long flags;
> >  	int i;
> >  
> > -	/* Setup an irq_host structure */
> > +	/* Setup an irq_domain structure */
> >  	socrates_fpga_pic_irq_host = irq_alloc_host(pic, IRQ_HOST_MAP_LINEAR,
> >  			SOCRATES_FPGA_NUM_IRQS,	&socrates_fpga_pic_host_ops,
> >  			SOCRATES_FPGA_NUM_IRQS);
> > diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
> > index 6df9e25..fed34ab 100644
> > --- a/arch/powerpc/platforms/86xx/gef_pic.c
> > +++ b/arch/powerpc/platforms/86xx/gef_pic.c
> > @@ -52,7 +52,7 @@
> >  static DEFINE_RAW_SPINLOCK(gef_pic_lock);
> >  
> >  static void __iomem *gef_pic_irq_reg_base;
> > -static struct irq_host *gef_pic_irq_host;
> > +static struct irq_domain *gef_pic_irq_host;
> >  static int gef_pic_cascade_irq;
> >  
> >  /*
> > @@ -159,7 +159,7 @@ static struct irq_chip gef_pic_chip = {
> >  /* When an interrupt is being configured, this call allows some flexibilty
> >   * in deciding which irq_chip structure is used
> >   */
> > -static int gef_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int gef_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hwirq)
> >  {
> >  	/* All interrupts are LEVEL sensitive */
> > @@ -169,7 +169,7 @@ static int gef_pic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int gef_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int gef_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			    const u32 *intspec, unsigned int intsize,
> >  			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  {
> > @@ -217,7 +217,7 @@ void __init gef_pic_init(struct device_node *np)
> >  		return;
> >  	}
> >  
> > -	/* Setup an irq_host structure */
> > +	/* Setup an irq_domain structure */
> >  	gef_pic_irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR,
> >  					  GEF_PIC_NUM_IRQS,
> >  					  &gef_pic_host_ops, NO_IRQ);
> > diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
> > index 9708553..db643a7 100644
> > --- a/arch/powerpc/platforms/cell/axon_msi.c
> > +++ b/arch/powerpc/platforms/cell/axon_msi.c
> > @@ -66,7 +66,7 @@
> >  
> >  
> >  struct axon_msic {
> > -	struct irq_host *irq_host;
> > +	struct irq_domain *irq_host;
> >  	__le32 *fifo_virt;
> >  	dma_addr_t fifo_phys;
> >  	dcr_host_t dcr_host;
> > @@ -150,7 +150,7 @@ static void axon_msi_cascade(unsigned int irq, struct irq_desc *desc)
> >  
> >  static struct axon_msic *find_msi_translator(struct pci_dev *dev)
> >  {
> > -	struct irq_host *irq_host;
> > +	struct irq_domain *irq_host;
> >  	struct device_node *dn, *tmp;
> >  	const phandle *ph;
> >  	struct axon_msic *msic = NULL;
> > @@ -184,7 +184,7 @@ static struct axon_msic *find_msi_translator(struct pci_dev *dev)
> >  
> >  	irq_host = irq_find_host(dn);
> >  	if (!irq_host) {
> > -		dev_dbg(&dev->dev, "axon_msi: no irq_host found for node %s\n",
> > +		dev_dbg(&dev->dev, "axon_msi: no irq_domain found for node %s\n",
> >  			dn->full_name);
> >  		goto out_error;
> >  	}
> > @@ -316,7 +316,7 @@ static struct irq_chip msic_irq_chip = {
> >  	.name		= "AXON-MSI",
> >  };
> >  
> > -static int msic_host_map(struct irq_host *h, unsigned int virq,
> > +static int msic_host_map(struct irq_domain *h, unsigned int virq,
> >  			 irq_hw_number_t hw)
> >  {
> >  	set_irq_chip_and_handler(virq, &msic_irq_chip, handle_simple_irq);
> > @@ -395,7 +395,7 @@ static int axon_msi_probe(struct platform_device *device,
> >  	msic->irq_host = irq_alloc_host(dn, IRQ_HOST_MAP_NOMAP,
> >  					NR_IRQS, &msic_host_ops, 0);
> >  	if (!msic->irq_host) {
> > -		printk(KERN_ERR "axon_msi: couldn't allocate irq_host for %s\n",
> > +		printk(KERN_ERR "axon_msi: couldn't allocate irq_domain for %s\n",
> >  		       dn->full_name);
> >  		goto out_free_fifo;
> >  	}
> > diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
> > index 682af97..179430d 100644
> > --- a/arch/powerpc/platforms/cell/beat_interrupt.c
> > +++ b/arch/powerpc/platforms/cell/beat_interrupt.c
> > @@ -34,7 +34,7 @@ static DEFINE_RAW_SPINLOCK(beatic_irq_mask_lock);
> >  static uint64_t	beatic_irq_mask_enable[(MAX_IRQS+255)/64];
> >  static uint64_t	beatic_irq_mask_ack[(MAX_IRQS+255)/64];
> >  
> > -static struct irq_host *beatic_host;
> > +static struct irq_domain *beatic_host;
> >  
> >  /*
> >   * In this implementation, "virq" == "IRQ plug number",
> > @@ -122,7 +122,7 @@ static struct irq_chip beatic_pic = {
> >   *
> >   * Note that the number (virq) is already assigned at upper layer.
> >   */
> > -static void beatic_pic_host_unmap(struct irq_host *h, unsigned int virq)
> > +static void beatic_pic_host_unmap(struct irq_domain *h, unsigned int virq)
> >  {
> >  	beat_destruct_irq_plug(virq);
> >  }
> > @@ -133,7 +133,7 @@ static void beatic_pic_host_unmap(struct irq_host *h, unsigned int virq)
> >   *
> >   * Note that the number (virq) is already assigned at upper layer.
> >   */
> > -static int beatic_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int beatic_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			       irq_hw_number_t hw)
> >  {
> >  	struct irq_desc *desc = irq_to_desc(virq);
> > @@ -152,7 +152,7 @@ static int beatic_pic_host_map(struct irq_host *h, unsigned int virq,
> >   * Update binding hardware IRQ number (hw) and Virtuql
> >   * IRQ number (virq). This is called only once for a given mapping.
> >   */
> > -static void beatic_pic_host_remap(struct irq_host *h, unsigned int virq,
> > +static void beatic_pic_host_remap(struct irq_domain *h, unsigned int virq,
> >  			       irq_hw_number_t hw)
> >  {
> >  	beat_construct_and_connect_irq_plug(virq, hw);
> > @@ -165,7 +165,7 @@ static void beatic_pic_host_remap(struct irq_host *h, unsigned int virq,
> >   * Called from irq_create_of_mapping() only.
> >   * Note: We have only 1 entry to translate.
> >   */
> > -static int beatic_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int beatic_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  				 const u32 *intspec, unsigned int intsize,
> >  				 irq_hw_number_t *out_hwirq,
> >  				 unsigned int *out_flags)
> > @@ -177,7 +177,7 @@ static int beatic_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> >  	return 0;
> >  }
> >  
> > -static int beatic_pic_host_match(struct irq_host *h, struct device_node *np)
> > +static int beatic_pic_host_match(struct irq_domain *h, struct device_node *np)
> >  {
> >  	/* Match all */
> >  	return 1;
> > diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
> > index 10eb1a4..2cfb3ee 100644
> > --- a/arch/powerpc/platforms/cell/interrupt.c
> > +++ b/arch/powerpc/platforms/cell/interrupt.c
> > @@ -56,7 +56,7 @@ struct iic {
> >  
> >  static DEFINE_PER_CPU(struct iic, cpu_iic);
> >  #define IIC_NODE_COUNT	2
> > -static struct irq_host *iic_host;
> > +static struct irq_domain *iic_host;
> >  
> >  /* Convert between "pending" bits and hw irq number */
> >  static irq_hw_number_t iic_pending_to_hwnum(struct cbe_iic_pending_bits bits)
> > @@ -184,7 +184,7 @@ void iic_cause_IPI(int cpu, int mesg)
> >  	out_be64(&per_cpu(cpu_iic, cpu).regs->generate, (0xf - mesg) << 4);
> >  }
> >  
> > -struct irq_host *iic_get_irq_host(int node)
> > +struct irq_domain *iic_get_irq_host(int node)
> >  {
> >  	return iic_host;
> >  }
> > @@ -227,7 +227,7 @@ void iic_request_IPIs(void)
> >  #endif /* CONFIG_SMP */
> >  
> >  
> > -static int iic_host_match(struct irq_host *h, struct device_node *node)
> > +static int iic_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	return of_device_is_compatible(node,
> >  				    "IBM,CBEA-Internal-Interrupt-Controller");
> > @@ -279,7 +279,7 @@ out_eoi:
> >  	raw_spin_unlock(&desc->lock);
> >  }
> >  
> > -static int iic_host_map(struct irq_host *h, unsigned int virq,
> > +static int iic_host_map(struct irq_domain *h, unsigned int virq,
> >  			irq_hw_number_t hw)
> >  {
> >  	switch (hw & IIC_IRQ_TYPE_MASK) {
> > @@ -296,7 +296,7 @@ static int iic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int iic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int iic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			   const u32 *intspec, unsigned int intsize,
> >  			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  
> > diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
> > index 5876e88..815a613 100644
> > --- a/arch/powerpc/platforms/cell/spider-pic.c
> > +++ b/arch/powerpc/platforms/cell/spider-pic.c
> > @@ -62,7 +62,7 @@ enum {
> >  #define SPIDER_IRQ_INVALID	63
> >  
> >  struct spider_pic {
> > -	struct irq_host		*host;
> > +	struct irq_domain      	*host;
> >  	void __iomem		*regs;
> >  	unsigned int		node_id;
> >  };
> > @@ -175,7 +175,7 @@ static struct irq_chip spider_pic = {
> >  	.set_type = spider_set_irq_type,
> >  };
> >  
> > -static int spider_host_map(struct irq_host *h, unsigned int virq,
> > +static int spider_host_map(struct irq_domain *h, unsigned int virq,
> >  			irq_hw_number_t hw)
> >  {
> >  	set_irq_chip_and_handler(virq, &spider_pic, handle_level_irq);
> > @@ -186,7 +186,7 @@ static int spider_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int spider_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int spider_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			   const u32 *intspec, unsigned int intsize,
> >  			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  
> > diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
> > index c278bd3..80021c3 100644
> > --- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
> > +++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
> > @@ -96,9 +96,9 @@ static struct irq_chip flipper_pic = {
> >   *
> >   */
> >  
> > -static struct irq_host *flipper_irq_host;
> > +static struct irq_domain *flipper_irq_host;
> >  
> > -static int flipper_pic_map(struct irq_host *h, unsigned int virq,
> > +static int flipper_pic_map(struct irq_domain *h, unsigned int virq,
> >  			   irq_hw_number_t hwirq)
> >  {
> >  	set_irq_chip_data(virq, h->host_data);
> > @@ -107,13 +107,13 @@ static int flipper_pic_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static void flipper_pic_unmap(struct irq_host *h, unsigned int irq)
> > +static void flipper_pic_unmap(struct irq_domain *h, unsigned int irq)
> >  {
> >  	set_irq_chip_data(irq, NULL);
> >  	set_irq_chip(irq, NULL);
> >  }
> >  
> > -static int flipper_pic_match(struct irq_host *h, struct device_node *np)
> > +static int flipper_pic_match(struct irq_domain *h, struct device_node *np)
> >  {
> >  	return 1;
> >  }
> > @@ -137,10 +137,10 @@ static void __flipper_quiesce(void __iomem *io_base)
> >  	out_be32(io_base + FLIPPER_ICR, 0xffffffff);
> >  }
> >  
> > -struct irq_host * __init flipper_pic_init(struct device_node *np)
> > +struct irq_domain * __init flipper_pic_init(struct device_node *np)
> >  {
> >  	struct device_node *pi;
> > -	struct irq_host *irq_host = NULL;
> > +	struct irq_domain *irq_host = NULL;
> >  	struct resource res;
> >  	void __iomem *io_base;
> >  	int retval;
> > @@ -169,7 +169,7 @@ struct irq_host * __init flipper_pic_init(struct device_node *np)
> >  	irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, FLIPPER_NR_IRQS,
> >  				  &flipper_irq_host_ops, -1);
> >  	if (!irq_host) {
> > -		pr_err("failed to allocate irq_host\n");
> > +		pr_err("failed to allocate irq_domain\n");
> >  		return NULL;
> >  	}
> >  
> > diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
> > index a771f91..a41ab12 100644
> > --- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
> > +++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
> > @@ -89,9 +89,9 @@ static struct irq_chip hlwd_pic = {
> >   *
> >   */
> >  
> > -static struct irq_host *hlwd_irq_host;
> > +static struct irq_domain *hlwd_irq_host;
> >  
> > -static int hlwd_pic_map(struct irq_host *h, unsigned int virq,
> > +static int hlwd_pic_map(struct irq_domain *h, unsigned int virq,
> >  			   irq_hw_number_t hwirq)
> >  {
> >  	set_irq_chip_data(virq, h->host_data);
> > @@ -100,7 +100,7 @@ static int hlwd_pic_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static void hlwd_pic_unmap(struct irq_host *h, unsigned int irq)
> > +static void hlwd_pic_unmap(struct irq_domain *h, unsigned int irq)
> >  {
> >  	set_irq_chip_data(irq, NULL);
> >  	set_irq_chip(irq, NULL);
> > @@ -111,7 +111,7 @@ static struct irq_host_ops hlwd_irq_host_ops = {
> >  	.unmap = hlwd_pic_unmap,
> >  };
> >  
> > -static unsigned int __hlwd_pic_get_irq(struct irq_host *h)
> > +static unsigned int __hlwd_pic_get_irq(struct irq_domain *h)
> >  {
> >  	void __iomem *io_base = h->host_data;
> >  	int irq;
> > @@ -129,7 +129,7 @@ static unsigned int __hlwd_pic_get_irq(struct irq_host *h)
> >  static void hlwd_pic_irq_cascade(unsigned int cascade_virq,
> >  				      struct irq_desc *desc)
> >  {
> > -	struct irq_host *irq_host = get_irq_data(cascade_virq);
> > +	struct irq_domain *irq_host = get_irq_data(cascade_virq);
> >  	unsigned int virq;
> >  
> >  	raw_spin_lock(&desc->lock);
> > @@ -161,9 +161,9 @@ static void __hlwd_quiesce(void __iomem *io_base)
> >  	out_be32(io_base + HW_BROADWAY_ICR, 0xffffffff);
> >  }
> >  
> > -struct irq_host *hlwd_pic_init(struct device_node *np)
> > +struct irq_domain *hlwd_pic_init(struct device_node *np)
> >  {
> > -	struct irq_host *irq_host;
> > +	struct irq_domain *irq_host;
> >  	struct resource res;
> >  	void __iomem *io_base;
> >  	int retval;
> > @@ -186,7 +186,7 @@ struct irq_host *hlwd_pic_init(struct device_node *np)
> >  	irq_host = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, HLWD_NR_IRQS,
> >  				  &hlwd_irq_host_ops, -1);
> >  	if (!irq_host) {
> > -		pr_err("failed to allocate irq_host\n");
> > +		pr_err("failed to allocate irq_domain\n");
> >  		return NULL;
> >  	}
> >  	irq_host->host_data = io_base;
> > @@ -206,7 +206,7 @@ unsigned int hlwd_pic_get_irq(void)
> >  
> >  void hlwd_pic_probe(void)
> >  {
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  	struct device_node *np;
> >  	const u32 *interrupts;
> >  	int cascade_virq;
> > diff --git a/arch/powerpc/platforms/iseries/irq.c b/arch/powerpc/platforms/iseries/irq.c
> > index ba446bf..948af76 100644
> > --- a/arch/powerpc/platforms/iseries/irq.c
> > +++ b/arch/powerpc/platforms/iseries/irq.c
> > @@ -338,7 +338,7 @@ unsigned int iSeries_get_irq(void)
> >  
> >  #ifdef CONFIG_PCI
> >  
> > -static int iseries_irq_host_map(struct irq_host *h, unsigned int virq,
> > +static int iseries_irq_host_map(struct irq_domain *h, unsigned int virq,
> >  				irq_hw_number_t hw)
> >  {
> >  	set_irq_chip_and_handler(virq, &iseries_pic, handle_fasteoi_irq);
> > @@ -346,7 +346,7 @@ static int iseries_irq_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int iseries_irq_host_match(struct irq_host *h, struct device_node *np)
> > +static int iseries_irq_host_match(struct irq_domain *h, struct device_node *np)
> >  {
> >  	/* Match all */
> >  	return 1;
> > @@ -364,7 +364,7 @@ static struct irq_host_ops iseries_irq_host_ops = {
> >  void __init iSeries_init_IRQ(void)
> >  {
> >  	/* Register PCI event handler and open an event path */
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  	int ret;
> >  
> >  	/*
> > diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
> > index 890d5f7..db69f2b 100644
> > --- a/arch/powerpc/platforms/powermac/pic.c
> > +++ b/arch/powerpc/platforms/powermac/pic.c
> > @@ -67,7 +67,7 @@ static DEFINE_RAW_SPINLOCK(pmac_pic_lock);
> >  static unsigned long ppc_lost_interrupts[NR_MASK_WORDS];
> >  static unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
> >  static int pmac_irq_cascade = -1;
> > -static struct irq_host *pmac_pic_host;
> > +static struct irq_domain *pmac_pic_host;
> >  
> >  static void __pmac_retrigger(unsigned int irq_nr)
> >  {
> > @@ -280,13 +280,13 @@ static struct irqaction gatwick_cascade_action = {
> >  	.name		= "cascade",
> >  };
> >  
> > -static int pmac_pic_host_match(struct irq_host *h, struct device_node *node)
> > +static int pmac_pic_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	/* We match all, we don't always have a node anyway */
> >  	return 1;
> >  }
> >  
> > -static int pmac_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int pmac_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			     irq_hw_number_t hw)
> >  {
> >  	struct irq_desc *desc = irq_to_desc(virq);
> > @@ -306,7 +306,7 @@ static int pmac_pic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int pmac_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int pmac_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			       const u32 *intspec, unsigned int intsize,
> >  			       irq_hw_number_t *out_hwirq,
> >  			       unsigned int *out_flags)
> > diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
> > index 59d9712..71fec2e 100644
> > --- a/arch/powerpc/platforms/ps3/interrupt.c
> > +++ b/arch/powerpc/platforms/ps3/interrupt.c
> > @@ -659,12 +659,12 @@ static void __maybe_unused _dump_mask(struct ps3_private *pd,
> >  static void dump_bmp(struct ps3_private* pd) {};
> >  #endif /* defined(DEBUG) */
> >  
> > -static void ps3_host_unmap(struct irq_host *h, unsigned int virq)
> > +static void ps3_host_unmap(struct irq_domain *h, unsigned int virq)
> >  {
> >  	set_irq_chip_data(virq, NULL);
> >  }
> >  
> > -static int ps3_host_map(struct irq_host *h, unsigned int virq,
> > +static int ps3_host_map(struct irq_domain *h, unsigned int virq,
> >  	irq_hw_number_t hwirq)
> >  {
> >  	pr_debug("%s:%d: hwirq %lu, virq %u\n", __func__, __LINE__, hwirq,
> > @@ -675,7 +675,7 @@ static int ps3_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int ps3_host_match(struct irq_host *h, struct device_node *np)
> > +static int ps3_host_match(struct irq_domain *h, struct device_node *np)
> >  {
> >  	/* Match all */
> >  	return 1;
> > @@ -733,7 +733,7 @@ void __init ps3_init_IRQ(void)
> >  {
> >  	int result;
> >  	unsigned cpu;
> > -	struct irq_host *host;
> > +	struct irq_domain *host;
> >  
> >  	host = irq_alloc_host(NULL, IRQ_HOST_MAP_NOMAP, 0, &ps3_host_ops,
> >  		PS3_INVALID_OUTLET);
> > diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
> > index 93834b0..ee3a2ad 100644
> > --- a/arch/powerpc/platforms/pseries/xics.c
> > +++ b/arch/powerpc/platforms/pseries/xics.c
> > @@ -33,7 +33,7 @@
> >  #include "xics.h"
> >  #include "plpar_wrappers.h"
> >  
> > -static struct irq_host *xics_host;
> > +static struct irq_domain *xics_host;
> >  
> >  #define XICS_IPI		2
> >  #define XICS_IRQ_SPURIOUS	0
> > @@ -452,7 +452,7 @@ static struct irq_chip xics_pic_lpar = {
> >  /* Points to the irq_chip we're actually using */
> >  static struct irq_chip *xics_irq_chip;
> >  
> > -static int xics_host_match(struct irq_host *h, struct device_node *node)
> > +static int xics_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	/* IBM machines have interrupt parents of various funky types for things
> >  	 * like vdevices, events, etc... The trick we use here is to match
> > @@ -461,7 +461,7 @@ static int xics_host_match(struct irq_host *h, struct device_node *node)
> >  	return !of_device_is_compatible(node, "chrp,iic");
> >  }
> >  
> > -static int xics_host_map(struct irq_host *h, unsigned int virq,
> > +static int xics_host_map(struct irq_domain *h, unsigned int virq,
> >  			 irq_hw_number_t hw)
> >  {
> >  	pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
> > @@ -474,7 +474,7 @@ static int xics_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int xics_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int xics_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			   const u32 *intspec, unsigned int intsize,
> >  			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  
> > diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
> > index 0085212..2f78da2 100644
> > --- a/arch/powerpc/sysdev/cpm1.c
> > +++ b/arch/powerpc/sysdev/cpm1.c
> > @@ -54,7 +54,7 @@ cpm8xx_t __iomem *cpmp;  /* Pointer to comm processor space */
> >  immap_t __iomem *mpc8xx_immr;
> >  static cpic8xx_t __iomem *cpic_reg;
> >  
> > -static struct irq_host *cpm_pic_host;
> > +static struct irq_domain *cpm_pic_host;
> >  
> >  static void cpm_mask_irq(unsigned int irq)
> >  {
> > @@ -98,7 +98,7 @@ int cpm_get_irq(void)
> >  	return irq_linear_revmap(cpm_pic_host, cpm_vec);
> >  }
> >  
> > -static int cpm_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int cpm_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hw)
> >  {
> >  	pr_debug("cpm_pic_host_map(%d, 0x%lx)\n", virq, hw);
> > diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
> > index fcea4ff..4e18a8b 100644
> > --- a/arch/powerpc/sysdev/cpm2_pic.c
> > +++ b/arch/powerpc/sysdev/cpm2_pic.c
> > @@ -50,7 +50,7 @@
> >  
> >  static intctl_cpm2_t __iomem *cpm2_intctl;
> >  
> > -static struct irq_host *cpm2_pic_host;
> > +static struct irq_domain *cpm2_pic_host;
> >  #define NR_MASK_WORDS   ((NR_IRQS + 31) / 32)
> >  static unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
> >  
> > @@ -221,7 +221,7 @@ unsigned int cpm2_get_irq(void)
> >  	return irq_linear_revmap(cpm2_pic_host, irq);
> >  }
> >  
> > -static int cpm2_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int cpm2_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hw)
> >  {
> >  	pr_debug("cpm2_pic_host_map(%d, 0x%lx)\n", virq, hw);
> > @@ -231,7 +231,7 @@ static int cpm2_pic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int cpm2_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int cpm2_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			    const u32 *intspec, unsigned int intsize,
> >  			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  {
> > diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
> > index 87991d3..71086e6 100644
> > --- a/arch/powerpc/sysdev/fsl_msi.c
> > +++ b/arch/powerpc/sysdev/fsl_msi.c
> > @@ -57,7 +57,7 @@ static struct irq_chip fsl_msi_chip = {
> >  	.name		= "FSL-MSI",
> >  };
> >  
> > -static int fsl_msi_host_map(struct irq_host *h, unsigned int virq,
> > +static int fsl_msi_host_map(struct irq_domain *h, unsigned int virq,
> >  				irq_hw_number_t hw)
> >  {
> >  	struct fsl_msi *msi_data = h->host_data;
> > diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
> > index 624580c..3852988 100644
> > --- a/arch/powerpc/sysdev/fsl_msi.h
> > +++ b/arch/powerpc/sysdev/fsl_msi.h
> > @@ -24,7 +24,7 @@
> >  #define FSL_PIC_IP_IPIC	0x00000002
> >  
> >  struct fsl_msi {
> > -	struct irq_host *irqhost;
> > +	struct irq_domain *irqhost;
> >  
> >  	unsigned long cascade_irq;
> >  
> > diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
> > index 6323e70..ccb2892 100644
> > --- a/arch/powerpc/sysdev/i8259.c
> > +++ b/arch/powerpc/sysdev/i8259.c
> > @@ -25,7 +25,7 @@ static unsigned char cached_8259[2] = { 0xff, 0xff };
> >  
> >  static DEFINE_RAW_SPINLOCK(i8259_lock);
> >  
> > -static struct irq_host *i8259_host;
> > +static struct irq_domain *i8259_host;
> >  
> >  /*
> >   * Acknowledge the IRQ using either the PCI host bridge's interrupt
> > @@ -163,12 +163,12 @@ static struct resource pic_edgectrl_iores = {
> >  	.flags = IORESOURCE_BUSY,
> >  };
> >  
> > -static int i8259_host_match(struct irq_host *h, struct device_node *node)
> > +static int i8259_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	return h->of_node == NULL || h->of_node == node;
> >  }
> >  
> > -static int i8259_host_map(struct irq_host *h, unsigned int virq,
> > +static int i8259_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hw)
> >  {
> >  	pr_debug("i8259_host_map(%d, 0x%lx)\n", virq, hw);
> > @@ -185,7 +185,7 @@ static int i8259_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static void i8259_host_unmap(struct irq_host *h, unsigned int virq)
> > +static void i8259_host_unmap(struct irq_domain *h, unsigned int virq)
> >  {
> >  	/* Make sure irq is masked in hardware */
> >  	i8259_mask_irq(virq);
> > @@ -197,7 +197,7 @@ static void i8259_host_unmap(struct irq_host *h, unsigned int virq)
> >  	synchronize_irq(virq);
> >  }
> >  
> > -static int i8259_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int i8259_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			    const u32 *intspec, unsigned int intsize,
> >  			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  {
> > @@ -224,7 +224,7 @@ static struct irq_host_ops i8259_host_ops = {
> >  	.xlate = i8259_host_xlate,
> >  };
> >  
> > -struct irq_host *i8259_get_host(void)
> > +struct irq_domain *i8259_get_host(void)
> >  {
> >  	return i8259_host;
> >  }
> > diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
> > index d7b9b9c..ac0bd54 100644
> > --- a/arch/powerpc/sysdev/ipic.c
> > +++ b/arch/powerpc/sysdev/ipic.c
> > @@ -676,13 +676,13 @@ static struct irq_chip ipic_edge_irq_chip = {
> >  	.set_type	= ipic_set_irq_type,
> >  };
> >  
> > -static int ipic_host_match(struct irq_host *h, struct device_node *node)
> > +static int ipic_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	/* Exact match, unless ipic node is NULL */
> >  	return h->of_node == NULL || h->of_node == node;
> >  }
> >  
> > -static int ipic_host_map(struct irq_host *h, unsigned int virq,
> > +static int ipic_host_map(struct irq_domain *h, unsigned int virq,
> >  			 irq_hw_number_t hw)
> >  {
> >  	struct ipic *ipic = h->host_data;
> > @@ -696,7 +696,7 @@ static int ipic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int ipic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int ipic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			   const u32 *intspec, unsigned int intsize,
> >  			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  
> > diff --git a/arch/powerpc/sysdev/ipic.h b/arch/powerpc/sysdev/ipic.h
> > index 9391c57..fe31a00 100644
> > --- a/arch/powerpc/sysdev/ipic.h
> > +++ b/arch/powerpc/sysdev/ipic.h
> > @@ -43,7 +43,7 @@ struct ipic {
> >  	volatile u32 __iomem	*regs;
> >  
> >  	/* The remapper for this IPIC */
> > -	struct irq_host		*irqhost;
> > +	struct irq_domain	*irqhost;
> >  };
> >  
> >  struct ipic_info {
> > diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
> > index 8c27d26..f4bf039 100644
> > --- a/arch/powerpc/sysdev/mpc8xx_pic.c
> > +++ b/arch/powerpc/sysdev/mpc8xx_pic.c
> > @@ -18,7 +18,7 @@
> >  
> >  extern int cpm_get_irq(struct pt_regs *regs);
> >  
> > -static struct irq_host *mpc8xx_pic_host;
> > +static struct irq_domain *mpc8xx_pic_host;
> >  #define NR_MASK_WORDS   ((NR_IRQS + 31) / 32)
> >  static unsigned long ppc_cached_irq_mask[NR_MASK_WORDS];
> >  static sysconf8xx_t __iomem *siu_reg;
> > @@ -118,7 +118,7 @@ unsigned int mpc8xx_get_irq(void)
> >  
> >  }
> >  
> > -static int mpc8xx_pic_host_map(struct irq_host *h, unsigned int virq,
> > +static int mpc8xx_pic_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hw)
> >  {
> >  	pr_debug("mpc8xx_pic_host_map(%d, 0x%lx)\n", virq, hw);
> > @@ -129,7 +129,7 @@ static int mpc8xx_pic_host_map(struct irq_host *h, unsigned int virq,
> >  }
> >  
> >  
> > -static int mpc8xx_pic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int mpc8xx_pic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			    const u32 *intspec, unsigned int intsize,
> >  			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  {
> > diff --git a/arch/powerpc/sysdev/mpc8xxx_gpio.c b/arch/powerpc/sysdev/mpc8xxx_gpio.c
> > index 2b69084..3a6f206 100644
> > --- a/arch/powerpc/sysdev/mpc8xxx_gpio.c
> > +++ b/arch/powerpc/sysdev/mpc8xxx_gpio.c
> > @@ -36,7 +36,7 @@ struct mpc8xxx_gpio_chip {
> >  	 * open drain mode safely
> >  	 */
> >  	u32 data;
> > -	struct irq_host *irq;
> > +	struct irq_domain *irq;
> >  };
> >  
> >  static inline u32 mpc8xxx_gpio2mask(unsigned int gpio)
> > @@ -223,7 +223,7 @@ static struct irq_chip mpc8xxx_irq_chip = {
> >  	.set_type	= mpc8xxx_irq_set_type,
> >  };
> >  
> > -static int mpc8xxx_gpio_irq_map(struct irq_host *h, unsigned int virq,
> > +static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
> >  				irq_hw_number_t hw)
> >  {
> >  	set_irq_chip_data(virq, h->host_data);
> > @@ -233,7 +233,7 @@ static int mpc8xxx_gpio_irq_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int mpc8xxx_gpio_irq_xlate(struct irq_host *h, struct device_node *ct,
> > +static int mpc8xxx_gpio_irq_xlate(struct irq_domain *h, struct device_node *ct,
> >  				  const u32 *intspec, unsigned int intsize,
> >  				  irq_hw_number_t *out_hwirq,
> >  				  unsigned int *out_flags)
> > diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> > index 7c13426..a52e257 100644
> > --- a/arch/powerpc/sysdev/mpic.c
> > +++ b/arch/powerpc/sysdev/mpic.c
> > @@ -931,13 +931,13 @@ static struct irq_chip mpic_irq_ht_chip = {
> >  #endif /* CONFIG_MPIC_U3_HT_IRQS */
> >  
> >  
> > -static int mpic_host_match(struct irq_host *h, struct device_node *node)
> > +static int mpic_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	/* Exact match, unless mpic node is NULL */
> >  	return h->of_node == NULL || h->of_node == node;
> >  }
> >  
> > -static int mpic_host_map(struct irq_host *h, unsigned int virq,
> > +static int mpic_host_map(struct irq_domain *h, unsigned int virq,
> >  			 irq_hw_number_t hw)
> >  {
> >  	struct mpic *mpic = h->host_data;
> > @@ -987,7 +987,7 @@ static int mpic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int mpic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int mpic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			   const u32 *intspec, unsigned int intsize,
> >  			   irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  
> > diff --git a/arch/powerpc/sysdev/mv64x60_pic.c b/arch/powerpc/sysdev/mv64x60_pic.c
> > index 485b924..33fbc90 100644
> > --- a/arch/powerpc/sysdev/mv64x60_pic.c
> > +++ b/arch/powerpc/sysdev/mv64x60_pic.c
> > @@ -70,7 +70,7 @@ static u32 mv64x60_cached_low_mask;
> >  static u32 mv64x60_cached_high_mask = MV64X60_HIGH_GPP_GROUPS;
> >  static u32 mv64x60_cached_gpp_mask;
> >  
> > -static struct irq_host *mv64x60_irq_host;
> > +static struct irq_domain *mv64x60_irq_host;
> >  
> >  /*
> >   * mv64x60_chip_low functions
> > @@ -208,7 +208,7 @@ static struct irq_chip *mv64x60_chips[] = {
> >  	[MV64x60_LEVEL1_GPP]  = &mv64x60_chip_gpp,
> >  };
> >  
> > -static int mv64x60_host_map(struct irq_host *h, unsigned int virq,
> > +static int mv64x60_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hwirq)
> >  {
> >  	int level1;
> > diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
> > index 541ba98..f28fd8f 100644
> > --- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
> > +++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
> > @@ -243,13 +243,13 @@ static struct irq_chip qe_ic_irq_chip = {
> >  	.mask_ack = qe_ic_mask_irq,
> >  };
> >  
> > -static int qe_ic_host_match(struct irq_host *h, struct device_node *node)
> > +static int qe_ic_host_match(struct irq_domain *h, struct device_node *node)
> >  {
> >  	/* Exact match, unless qe_ic node is NULL */
> >  	return h->of_node == NULL || h->of_node == node;
> >  }
> >  
> > -static int qe_ic_host_map(struct irq_host *h, unsigned int virq,
> > +static int qe_ic_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hw)
> >  {
> >  	struct qe_ic *qe_ic = h->host_data;
> > @@ -270,7 +270,7 @@ static int qe_ic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int qe_ic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int qe_ic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			    const u32 * intspec, unsigned int intsize,
> >  			    irq_hw_number_t * out_hwirq,
> >  			    unsigned int *out_flags)
> > diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.h b/arch/powerpc/sysdev/qe_lib/qe_ic.h
> > index c1361d0..c327872 100644
> > --- a/arch/powerpc/sysdev/qe_lib/qe_ic.h
> > +++ b/arch/powerpc/sysdev/qe_lib/qe_ic.h
> > @@ -79,7 +79,7 @@ struct qe_ic {
> >  	volatile u32 __iomem *regs;
> >  
> >  	/* The remapper for this QEIC */
> > -	struct irq_host *irqhost;
> > +	struct irq_domain *irqhost;
> >  
> >  	/* The "linux" controller struct */
> >  	struct irq_chip hc_irq;
> > diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
> > index 0ab9281..7a9b37a 100644
> > --- a/arch/powerpc/sysdev/tsi108_pci.c
> > +++ b/arch/powerpc/sysdev/tsi108_pci.c
> > @@ -51,7 +51,7 @@
> >  u32 tsi108_pci_cfg_base;
> >  static u32 tsi108_pci_cfg_phys;
> >  u32 tsi108_csr_vir_base;
> > -static struct irq_host *pci_irq_host;
> > +static struct irq_domain *pci_irq_host;
> >  
> >  extern u32 get_vir_csrbase(void);
> >  extern u32 tsi108_read_reg(u32 reg_offset);
> > @@ -382,7 +382,7 @@ static struct irq_chip tsi108_pci_irq = {
> >  	.unmask = tsi108_pci_irq_enable,
> >  };
> >  
> > -static int pci_irq_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int pci_irq_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			    const u32 *intspec, unsigned int intsize,
> >  			    irq_hw_number_t *out_hwirq, unsigned int *out_flags)
> >  {
> > @@ -391,7 +391,7 @@ static int pci_irq_host_xlate(struct irq_host *h, struct device_node *ct,
> >  	return 0;
> >  }
> >  
> > -static int pci_irq_host_map(struct irq_host *h, unsigned int virq,
> > +static int pci_irq_host_map(struct irq_domain *h, unsigned int virq,
> >  			  irq_hw_number_t hw)
> >  {	unsigned int irq;
> >  	DBG("%s(%d, 0x%lx)\n", __func__, virq, hw);
> > diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
> > index 0038fb7..3c835f5 100644
> > --- a/arch/powerpc/sysdev/uic.c
> > +++ b/arch/powerpc/sysdev/uic.c
> > @@ -52,7 +52,7 @@ struct uic {
> >  	spinlock_t lock;
> >  
> >  	/* The remapper for this UIC */
> > -	struct irq_host	*irqhost;
> > +	struct irq_domain	*irqhost;
> >  };
> >  
> >  static void uic_unmask_irq(unsigned int virq)
> > @@ -185,7 +185,7 @@ static struct irq_chip uic_irq_chip = {
> >  	.set_type	= uic_set_irq_type,
> >  };
> >  
> > -static int uic_host_map(struct irq_host *h, unsigned int virq,
> > +static int uic_host_map(struct irq_domain *h, unsigned int virq,
> >  			irq_hw_number_t hw)
> >  {
> >  	struct uic *uic = h->host_data;
> > @@ -201,7 +201,7 @@ static int uic_host_map(struct irq_host *h, unsigned int virq,
> >  	return 0;
> >  }
> >  
> > -static int uic_host_xlate(struct irq_host *h, struct device_node *ct,
> > +static int uic_host_xlate(struct irq_domain *h, struct device_node *ct,
> >  			  const u32 *intspec, unsigned int intsize,
> >  			  irq_hw_number_t *out_hwirq, unsigned int *out_type)
> >  
> > diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
> > index 1e0ccfa..f6d18cb 100644
> > --- a/arch/powerpc/sysdev/xilinx_intc.c
> > +++ b/arch/powerpc/sysdev/xilinx_intc.c
> > @@ -40,7 +40,7 @@
> >  #define XINTC_IVR	24	/* Interrupt Vector */
> >  #define XINTC_MER	28	/* Master Enable */
> >  
> > -static struct irq_host *master_irqhost;
> > +static struct irq_domain *master_irqhost;
> >  
> >  #define XILINX_INTC_MAXIRQS	(32)
> >  
> > @@ -147,7 +147,7 @@ static struct irq_chip xilinx_intc_edge_irqchip = {
> >  /**
> >   * xilinx_intc_xlate - translate virq# from device tree interrupts property
> >   */
> > -static int xilinx_intc_xlate(struct irq_host *h, struct device_node *ct,
> > +static int xilinx_intc_xlate(struct irq_domain *h, struct device_node *ct,
> >  				const u32 *intspec, unsigned int intsize,
> >  				irq_hw_number_t *out_hwirq,
> >  				unsigned int *out_flags)
> > @@ -167,7 +167,7 @@ static int xilinx_intc_xlate(struct irq_host *h, struct device_node *ct,
> >  
> >  	return 0;
> >  }
> > -static int xilinx_intc_map(struct irq_host *h, unsigned int virq,
> > +static int xilinx_intc_map(struct irq_domain *h, unsigned int virq,
> >  				  irq_hw_number_t irq)
> >  {
> >  	set_irq_chip_data(virq, h->host_data);
> > @@ -188,10 +188,10 @@ static struct irq_host_ops xilinx_intc_ops = {
> >  	.xlate = xilinx_intc_xlate,
> >  };
> >  
> > -struct irq_host * __init
> > +struct irq_domain * __init
> >  xilinx_intc_init(struct device_node *np)
> >  {
> > -	struct irq_host * irq;
> > +	struct irq_domain * irq;
> >  	void * regs;
> >  
> >  	/* Find and map the intc registers */
> > @@ -206,7 +206,7 @@ xilinx_intc_init(struct device_node *np)
> >  	out_be32(regs + XINTC_IAR, ~(u32) 0); /* Acknowledge pending irqs */
> >  	out_be32(regs + XINTC_MER, 0x3UL); /* Turn on the Master Enable. */
> >  
> > -	/* Allocate and initialize an irq_host structure. */
> > +	/* Allocate and initialize an irq_domain structure. */
> >  	irq = irq_alloc_host(np, IRQ_HOST_MAP_LINEAR, XILINX_INTC_MAXIRQS,
> >  			     &xilinx_intc_ops, -1);
> >  	if (!irq)
> > -- 
> > 1.7.0.4
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


